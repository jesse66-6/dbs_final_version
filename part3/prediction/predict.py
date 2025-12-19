import pandas as pd
import numpy as np
import pickle
from sklearn.model_selection import train_test_split
from sklearn import metrics

# 1. Load the saved model dictionary
# We need to extract both the trained pipeline and the label encoder
model_path = "model.pkl"
try:
    with open(model_path, "rb") as f:
        loaded_obj = pickle.load(f)
    
    model = loaded_obj['pipeline']
    le = loaded_obj['label_encoder']
    print(f"✅ Model and LabelEncoder loaded from {model_path}")
except FileNotFoundError:
    print(f"❌ Error: File {model_path} not found.")
    exit()

# 2. Load new data (Simulating external data)
# Ensure this CSV has the same columns as the training data
data_path = "../dataset/customer_insurance_dataset.csv" # Using original for demo
data = pd.read_csv(data_path)

# === CRITICAL: Re-apply Feature Engineering ===
# The pipeline expects this column to exist, so we must calculate it again
data['IncomePerDependent'] = data['AnnualIncome'] / (data['NumberOfDependents'] + 1)

# 3. Define Features and Targets
# Select the exact columns used during training
feature_cols = ['Age', 'Gender', 'MaritalStatus', 'AnnualIncome', 
                'EducationLevel', 'NumberOfDependents', 'IncomePerDependent']

X = data[feature_cols]
y_raw = data['Target_InsuranceType'] # Original string labels

# Convert string targets to numbers for evaluation metrics (using the loaded encoder)
y = le.transform(y_raw)

# 4. Split into input/output (Following your reference code)
# In a real production scenario, you might skip this and predict on all data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

print(f"\n📊 Predicting on {len(X_test)} test samples...")

# 5. Get predicted outcomes
# The model returns numeric predictions (0, 1, 2...)
y_pred_num = model.predict(X_test)

# Convert numeric predictions back to human-readable strings
y_pred_str = le.inverse_transform(y_pred_num)
y_test_str = le.inverse_transform(y_test)

# Create a comparison DataFrame
pred_df = pd.DataFrame({
    'Actual_Label': y_test_str,
    'Predicted_Label': y_pred_str,
    'Actual_Code': y_test,
    'Predicted_Code': y_pred_num
})

print("\n--- First 10 Predictions ---")
print(pred_df.head(10))

# 6. Evaluate the model performance
# Note: For multiclass, we must specify the 'average' method (weighted or macro)
accuracy = metrics.accuracy_score(y_test, y_pred_num)
precision = metrics.precision_score(y_test, y_pred_num, average='weighted', zero_division=0)
recall = metrics.recall_score(y_test, y_pred_num, average='weighted', zero_division=0)
f1 = metrics.f1_score(y_test, y_pred_num, average='weighted', zero_division=0)

print(f"\n📈 Performance Metrics:")
print(f"Accuracy:  {accuracy:.4f}")
print(f"Precision: {precision:.4f}")
print(f"Recall:    {recall:.4f}")
print(f"F1-score:  {f1:.4f}")

# Detailed Report
print("\n📋 Classification Report:")
print(metrics.classification_report(y_test_str, y_pred_str, zero_division=0))