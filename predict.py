import pandas as pd
import numpy as np
import pickle
import os
from sklearn.model_selection import train_test_split
from sklearn import metrics
from database import get_db_connection  # Import DB connection to find the active model

# ==========================================
# 1. Dynamic Model Loading
# Queries the database to find the latest 'Active' model path
# ==========================================
def get_active_model_path():
    conn = get_db_connection()
    if not conn:
        print("❌ Database connection failed.")
        return None
    
    try:
        cursor = conn.cursor(dictionary=True)
        # Fetch the path of the currently active model from the registry
        cursor.execute("SELECT file_path FROM Model_Registry WHERE status='Active' ORDER BY model_id DESC LIMIT 1")
        record = cursor.fetchone()
        
        if record and os.path.exists(record['file_path']):
            return record['file_path']
        else:
            print("⚠️ No active model record found in DB.")
            return None
    except Exception as e:
        print(f"❌ Error querying model registry: {e}")
        return None
    finally:
        conn.close()

# Determine which file to load
model_path = get_active_model_path()

if not model_path:
    # Fallback for local testing if DB is empty
    model_path = "model.pkl" 
    print("⚠️ specific active model not found. Trying fallback 'model.pkl'...")

# Load the model artifact
try:
    with open(model_path, "rb") as f:
        loaded_obj = pickle.load(f)
    
    model = loaded_obj['pipeline']
    le = loaded_obj['label_encoder']
    print(f"✅ Model and LabelEncoder loaded from: {model_path}")
except FileNotFoundError:
    print(f"❌ Error: File {model_path} not found. Please run train_model.py first.")
    exit()

# ==========================================
# 2. Data Loading & Preprocessing
# ==========================================
data_path = "dataset/customer_insurance_dataset.csv" # Ensure path matches project structure
try:
    data = pd.read_csv(data_path)
except FileNotFoundError:
    print(f"❌ Dataset not found at {data_path}")
    exit()

# Feature Engineering (Must match training logic)
data['IncomePerDependent'] = data['AnnualIncome'] / (data['NumberOfDependents'] + 1)

# Select Features and Target
feature_cols = ['Age', 'Gender', 'MaritalStatus', 'AnnualIncome', 
                'EducationLevel', 'NumberOfDependents', 'IncomePerDependent']

X = data[feature_cols]
y_raw = data['Target_InsuranceType']

# Encode Targets using the loaded encoder
try:
    y = le.transform(y_raw)
except Exception as e:
    print(f"❌ Label Encoding Error: {e}. Check if CSV contains unknown labels.")
    exit()

# ==========================================
# 3. Evaluation
# ==========================================
# Split data (Simulating test environment)
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

print(f"\n📊 Predicting on {len(X_test)} test samples...")

# Generate Predictions
y_pred_num = model.predict(X_test)

# Decode predictions back to strings
y_pred_str = le.inverse_transform(y_pred_num)
y_test_str = le.inverse_transform(y_test)

# Create Comparison DataFrame
pred_df = pd.DataFrame({
    'Actual_Label': y_test_str,
    'Predicted_Label': y_pred_str,
    'Actual_Code': y_test,
    'Predicted_Code': y_pred_num
})

print("\n--- First 10 Predictions ---")
print(pred_df.head(10))

# Metrics Calculation
accuracy = metrics.accuracy_score(y_test, y_pred_num)
precision = metrics.precision_score(y_test, y_pred_num, average='weighted', zero_division=0)
recall = metrics.recall_score(y_test, y_pred_num, average='weighted', zero_division=0)
f1 = metrics.f1_score(y_test, y_pred_num, average='weighted', zero_division=0)

print(f"\n📈 Performance Metrics:")
print(f"Accuracy:  {accuracy:.4f}")
print(f"Precision: {precision:.4f}")
print(f"Recall:    {recall:.4f}")
print(f"F1-score:  {f1:.4f}")

# Detailed Classification Report
print("\n📋 Classification Report:")
print(metrics.classification_report(y_test_str, y_pred_str, zero_division=0))