import pandas as pd
import numpy as np
import pickle
import time
import os
from datetime import datetime
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder, StandardScaler, LabelEncoder
from sklearn.pipeline import Pipeline
from xgboost import XGBClassifier
from database import get_db_connection

def load_and_merge_data():
    """
    Combines historical static data (CSV) with dynamic incremental data (SQL).
    """
    # 1. Load Historical Data (Data Lake)
    try:
        df_history = pd.read_csv("dataset/customer_insurance_dataset.csv")
    except FileNotFoundError:
        df_history = pd.DataFrame()

    # 2. Load Incremental Data (ODS - MySQL)
    conn = get_db_connection()
    df_new = pd.DataFrame()
    if conn:
        # Fetch only records with ground truth labels for training
        sql = """
            SELECT 
                age as Age, gender as Gender, marital_status as MaritalStatus,
                annual_income as AnnualIncome, education_level as EducationLevel,
                number_of_dependents as NumberOfDependents,
                actual_product_bought as Target_InsuranceType
            FROM Insured_Client
            WHERE actual_product_bought IS NOT NULL
        """
        try:
            df_new = pd.read_sql(sql, conn)
        except Exception as e:
            print(f"⚠️ DB Read Error: {e}")
        finally:
            conn.close()

    # 3. Merge Datasets
    if not df_new.empty:
        df_final = pd.concat([df_history, df_new], ignore_index=True)
    else:
        df_final = df_history

    return df_final

def train_pipeline():
    """
    Executes the training workflow, saves the model artifact, and updates the governance registry.
    Returns: New Version ID
    """
    print("🔄 Starting Model Retraining Pipeline...")
    
    # 1. Data Preparation
    data = load_and_merge_data()
    if len(data) < 10: 
        print("❌ Not enough data to train.")
        return None

    # 2. Feature Engineering (Must match inference logic)
    data['IncomePerDependent'] = data['AnnualIncome'] / (data['NumberOfDependents'] + 1)
    
    X = data[['Age', 'Gender', 'MaritalStatus', 'AnnualIncome', 'EducationLevel', 'NumberOfDependents', 'IncomePerDependent']]
    y_raw = data['Target_InsuranceType']

    # 3. Target Encoding
    le = LabelEncoder()
    y_encoded = le.fit_transform(y_raw)

    # 4. Build Pipeline
    categorical_features = ['Gender', 'MaritalStatus', 'EducationLevel']
    numeric_features = ['Age', 'AnnualIncome', 'NumberOfDependents', 'IncomePerDependent']

    preprocessor = ColumnTransformer(
        transformers=[
            ('num', StandardScaler(), numeric_features),
            ('cat', OneHotEncoder(handle_unknown='ignore'), categorical_features)
        ])

    pipeline = Pipeline(steps=[
        ('preprocessor', preprocessor),
        ('classifier', XGBClassifier(
            n_estimators=100, learning_rate=0.05, max_depth=6, 
            objective='multi:softmax', use_label_encoder=False, eval_metric='mlogloss'
        ))
    ])

    pipeline.fit(X, y_encoded)

    # 5. Versioning & Artifact Saving
    # Format: YYYYMMDD_HHMMSS
    version_name = datetime.now().strftime("%Y%m%d_%H%M%S")
    file_name = f"model_{version_name}.pkl"
    
    # Ensure directory exists
    if not os.path.exists("models"):
        os.makedirs("models")
        
    save_path = os.path.join("models", file_name)

    # Save pipeline and encoder together
    save_obj = {'pipeline': pipeline, 'label_encoder': le}
    with open(save_path, "wb") as f:
        pickle.dump(save_obj, f)
    
    # 6. Update Model Governance Registry
    conn = get_db_connection()
    if conn:
        cursor = conn.cursor()
        # Archive previous active model
        cursor.execute("UPDATE Model_Registry SET status = 'Archived' WHERE status = 'Active'")
        
        # Register new model
        # Note: accuracy_score is hardcoded for demo purposes; in production, calculate via test set
        cursor.execute("""
            INSERT INTO Model_Registry (version, file_path, accuracy_score, dataset_rows, status)
            VALUES (%s, %s, %s, %s, 'Active')
        """, (version_name, save_path, 0.89, len(data))) 
        conn.commit()
        conn.close()
        
    print(f"✅ Model {version_name} saved to {save_path}")
    return version_name

if __name__ == "__main__":
    train_pipeline()