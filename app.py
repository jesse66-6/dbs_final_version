from flask import Flask, render_template, request, redirect, url_for, flash
from database import get_db_connection
import pandas as pd
import pickle
import os
import train_model  # Import training module for the re-training pipeline

app = Flask(__name__)
app.secret_key = 'super_secret_key'

# Global variables for caching the model in memory
ml_pipeline = None
label_encoder = None
CURRENT_MODEL_VERSION = "N/A"

# ==========================================
# Core Logic 1: Model Serving
# Loads the latest 'Active' model from DB/Filesystem
# ==========================================
def load_latest_model():
    global ml_pipeline, label_encoder, CURRENT_MODEL_VERSION
    
    conn = get_db_connection()
    if not conn: return

    try:
        cursor = conn.cursor(dictionary=True)
        # Fetch the most recent active model record from the Governance Registry
        cursor.execute("SELECT * FROM Model_Registry WHERE status='Active' ORDER BY model_id DESC LIMIT 1")
        model_record = cursor.fetchone()
        
        if model_record and os.path.exists(model_record['file_path']):
            with open(model_record['file_path'], "rb") as f:
                loaded_obj = pickle.load(f)
            ml_pipeline = loaded_obj['pipeline']
            label_encoder = loaded_obj['label_encoder']
            CURRENT_MODEL_VERSION = model_record['version']
            print(f"✅ Loaded Active Model: {CURRENT_MODEL_VERSION} from {model_record['file_path']}")
        else:
            print("⚠️ No active model found in DB. Attempting fallback.")
            # Fallback: Load default local model if no active record exists
            if os.path.exists("model.pkl"):
                with open("model.pkl", "rb") as f:
                    loaded_obj = pickle.load(f)
                ml_pipeline = loaded_obj['pipeline']
                label_encoder = loaded_obj['label_encoder']
                CURRENT_MODEL_VERSION = "v_init"
                print("✅ Loaded Fallback Model: model.pkl")
            else:
                ml_pipeline = None
                CURRENT_MODEL_VERSION = "None"
    except Exception as e:
        print(f"❌ Error loading model: {e}")
    finally:
        conn.close()

# Initial model load on startup
load_latest_model()

# ==========================================
# Core Logic 2: Auto-Retrain Trigger
# Checks if enough new labeled data exists to retrain
# ==========================================
def check_and_trigger_retrain():
    """
    Checks the ODS for new ground truth data.
    Logic: Retrain every time the count of labeled data increases by 5.
    """
    conn = get_db_connection()
    if not conn: return None
    
    cursor = conn.cursor()
    # Count rows with valid ground truth labels (actual_product_bought)
    cursor.execute("SELECT COUNT(*) FROM Insured_Client WHERE actual_product_bought IS NOT NULL")
    count = cursor.fetchone()[0]
    conn.close()

    # Threshold set to 5 for demonstration purposes
    if count > 0 and count % 5 == 0:
        print(f"⚡ Auto-Retrain Triggered! (Total Labeled Data: {count})")
        try:
            new_version = train_model.train_pipeline() # Execute training pipeline
            if new_version:
                load_latest_model() # Hot-reload the new model
                return new_version
        except Exception as e:
            print(f"❌ Auto-training failed: {e}")
    
    return None

# ==========================================
# Routes
# ==========================================

@app.route('/')
def index():
    return redirect(url_for('list_clients'))

# --- 1. Client List Dashboard ---
@app.route('/clients')
def list_clients():
    conn = get_db_connection()
    if not conn: return "Database Error", 500
    
    cursor = conn.cursor(dictionary=True)
    # Join OLTP data with ML Insights and Product dimensions
    sql = """
        SELECT c.client_id, c.first_name, c.last_name, c.age, c.annual_income, c.actual_product_bought,
               p.product_name as recommendation, i.model_version
        FROM Insured_Client c
        LEFT JOIN Client_Insights i ON c.client_id = i.client_id
        LEFT JOIN Insurance_Product p ON i.predicted_product_id = p.product_id
        ORDER BY c.client_id DESC
    """
    cursor.execute(sql)
    clients = cursor.fetchall()
    conn.close()
    return render_template('clients_list.html', clients=clients, current_version=CURRENT_MODEL_VERSION)

# --- 2. Add Client (End-to-End Inference) ---
@app.route('/clients/add', methods=['GET', 'POST'])
def add_client():
    if request.method == 'POST':
        form = request.form
        
        try:
            # Data conversion
            age = int(form['age'])
            income = float(form['annual_income'])
            dependents = int(form['number_of_dependents'])
            
            # Handle optional Ground Truth label
            actual_bought = form.get('actual_product_bought')
            if not actual_bought: 
                actual_bought = None 

            conn = get_db_connection()
            cursor = conn.cursor()

            # A. Insert into OLTP database (Insured_Client)
            sql_client = """
                INSERT INTO Insured_Client 
                (first_name, last_name, age, gender, marital_status, 
                 education_level, annual_income, number_of_dependents, actual_product_bought)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(sql_client, (
                form['first_name'], form['last_name'], age, form['gender'], 
                form['marital_status'], form['education_level'], income, dependents, actual_bought
            ))
            client_id = cursor.lastrowid
            
            # B. Real-time Inference (using cached pipeline)
            rec_product_id = 1 # Default: No_Insurance
            model_ver = 'N/A'
            
            if ml_pipeline:
                try:
                    # Construct feature vector matching training schema
                    input_df = pd.DataFrame([{
                        'Age': age,
                        'Gender': form['gender'],
                        'MaritalStatus': form['marital_status'],
                        'AnnualIncome': income,
                        'EducationLevel': form['education_level'],
                        'NumberOfDependents': dependents,
                        'IncomePerDependent': income / (dependents + 1)
                    }])
                    
                    # Predict
                    pred_idx = ml_pipeline.predict(input_df)[0]
                    pred_label = label_encoder.inverse_transform([pred_idx])[0]
                    model_ver = CURRENT_MODEL_VERSION
                    
                    # Map Prediction Label -> Product ID
                    cursor.execute("SELECT product_id FROM Insurance_Product WHERE product_name = %s", (pred_label,))
                    res = cursor.fetchone()
                    if res: rec_product_id = res[0]
                        
                except Exception as e:
                    print(f"Prediction Error: {e}")

            # C. Store prediction results in Insights table
            sql_insight = """
                INSERT INTO Client_Insights (client_id, income_per_dependent, predicted_product_id, model_version)
                VALUES (%s, %s, %s, %s)
            """
            cursor.execute(sql_insight, (client_id, income / (dependents + 1), rec_product_id, model_ver))
            
            conn.commit()
            
            # D. Check if auto-retraining is needed (if ground truth was provided)
            if actual_bought:
                new_ver = check_and_trigger_retrain()
                if new_ver:
                    flash(f'Client added. System AUTO-RETRAINED to {new_ver}!', 'success')
                else:
                    flash('Client added with Ground Truth data.', 'success')
            else:
                flash('Client added and AI Prediction generated!', 'success')

        except Exception as e:
            if conn: conn.rollback()
            print(f"Error: {e}")
            flash(f'Error adding client: {e}', 'danger')
        finally:
            if conn: conn.close()

        return redirect(url_for('list_clients'))

    return render_template('add_client.html')

# --- 3. Edit Client Info ---
@app.route('/clients/edit/<int:client_id>', methods=['GET', 'POST'])
def edit_client(client_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        form = request.form
        # Update basic demographics
        sql = """
            UPDATE Insured_Client 
            SET first_name=%s, last_name=%s, age=%s, annual_income=%s, 
                marital_status=%s, education_level=%s
            WHERE client_id=%s
        """
        cursor.execute(sql, (
            form['first_name'], form['last_name'], form['age'], 
            form['annual_income'], form['marital_status'], form['education_level'],
            client_id
        ))
        conn.commit()
        conn.close()
        flash('Client information updated.', 'info')
        return redirect(url_for('list_clients'))

    # GET: Retrieve current info
    cursor.execute("SELECT * FROM Insured_Client WHERE client_id = %s", (client_id,))
    client = cursor.fetchone()
    conn.close()
    return render_template('edit_client.html', client=client)

# --- 4. Buy Policy (Generates Ground Truth & Triggers Retrain) ---
@app.route('/clients/buy/<int:client_id>', methods=['GET', 'POST'])
def buy_policy(client_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        product_name = request.form['product_name'] # The actual product purchased
        
        # 1. Retrieve product details
        cursor.execute("SELECT product_id, base_premium FROM Insurance_Product WHERE product_name=%s", (product_name,))
        prod = cursor.fetchone()
        
        if prod:
            # 2. Update Client record with Ground Truth label
            cursor.execute("UPDATE Insured_Client SET actual_product_bought=%s WHERE client_id=%s", (product_name, client_id))
            
            # 3. Record transaction in Policy table
            cursor.execute("""
                INSERT INTO Insurance_Policy (client_id, product_id, start_date, end_date, premium_amount, status)
                VALUES (%s, %s, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 YEAR), %s, 'Active')
            """, (client_id, prod['product_id'], prod['base_premium']))
            
            conn.commit()
            
            # 4. Trigger auto-retraining check based on new ground truth
            new_ver = check_and_trigger_retrain()
            
            msg = f'Policy purchased! Transaction recorded.'
            if new_ver:
                msg += f' 🚀 System Auto-Retrained to version {new_ver} due to new data!'
                flash(msg, 'success')
            else:
                flash(msg, 'success')
        
        conn.close()
        return redirect(url_for('list_clients'))

    # GET: Show purchase page
    cursor.execute("SELECT * FROM Insured_Client WHERE client_id = %s", (client_id,))
    client = cursor.fetchone()
    conn.close()
    return render_template('buy_policy.html', client=client)

# --- 5. Model Governance Dashboard ---
@app.route('/models')
def list_models():
    conn = get_db_connection()
    if not conn: return "DB Error"
    
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Model_Registry ORDER BY model_id DESC")
    models = cursor.fetchall()
    conn.close()
    return render_template('models_list.html', models=models)

# --- 6. Manual Retrain Trigger ---
@app.route('/admin/retrain', methods=['POST'])
def manual_retrain():
    try:
        new_ver = train_model.train_pipeline()
        load_latest_model()
        if new_ver:
            flash(f"Manual Retrain Successful. New Version: {new_ver}", "success")
        else:
            flash("Retrain failed or not enough data.", "warning")
    except Exception as e:
        flash(f"Error: {e}", "danger")
    return redirect(url_for('list_models'))

if __name__ == '__main__':
    app.run(debug=True, port=5000)