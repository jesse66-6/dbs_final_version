import pandas as pd
import numpy as np
import pickle
from sklearn.model_selection import train_test_split
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder, StandardScaler, LabelEncoder
from sklearn.pipeline import Pipeline
from sklearn import metrics
from xgboost import XGBClassifier

# 1. Load Data
try:
    data_path = "../dataset/customer_insurance_dataset.csv"
    data = pd.read_csv(data_path)
    print(f"✅ Data loaded. Total rows: {len(data)}")
except FileNotFoundError:
    print(f"❌ Error: File not found at {data_path}")
    exit()

# === Feature Engineering ===
# Create 'IncomePerDependent' to better reflect financial burden per person
data['IncomePerDependent'] = data['AnnualIncome'] / (data['NumberOfDependents'] + 1)

# 2. Define Features and Targets
X = data[['Age', 'Gender', 'MaritalStatus', 'AnnualIncome', 'EducationLevel', 'NumberOfDependents', 'IncomePerDependent']]
y_multi_raw = data['Target_InsuranceType']  # Original string labels
y_binary = data['Target_BoughtInsurance']

# === Encode Labels for XGBoost ===
# XGBoost requires numeric target labels (0, 1, 2...), not strings
le = LabelEncoder()
y_multi_encoded = le.fit_transform(y_multi_raw)

# Identify the index for 'No_Insurance' to reconstruct binary accuracy later
try:
    # Ensure this string matches the actual label in your CSV for "Did not buy"
    none_class_index = le.transform(['No_Insurance'])[0] 
    print(f"ℹ️ 'No_Insurance' encoded as index: {none_class_index}")
except ValueError:
    print("⚠️ Warning: 'No_Insurance' label not found in data.")
    none_class_index = -1 

# 3. Preprocessing
categorical_features = ['Gender', 'MaritalStatus', 'EducationLevel']
numeric_features = ['Age', 'AnnualIncome', 'NumberOfDependents', 'IncomePerDependent']

preprocessor = ColumnTransformer(
    transformers=[
        ('num', StandardScaler(), numeric_features),
        ('cat', OneHotEncoder(handle_unknown='ignore'), categorical_features)
    ])

# 4. Build XGBoost Pipeline
model_pipeline = Pipeline(steps=[
    ('preprocessor', preprocessor),
    ('classifier', XGBClassifier(
        n_estimators=200,        # Number of gradient boosted trees
        learning_rate=0.05,      # Step size shrinkage to prevent overfitting
        max_depth=6,             # Maximum depth of a tree
        subsample=0.8,           # Subsample ratio of the training instances
        colsample_bytree=0.8,    # Subsample ratio of columns when constructing each tree
        objective='multi:softmax', # Multiclass classification
        eval_metric='mlogloss',
        use_label_encoder=False,
        n_jobs=-1,               # Use all CPU cores
        random_state=42
    ))
])

# 5. Train-Test Split
# Splitting using the numerically encoded target labels
X_train, X_test, y_train_enc, y_test_enc, y_binary_train, y_binary_test = train_test_split(
    X, y_multi_encoded, y_binary, test_size=0.2, random_state=42, stratify=y_multi_encoded
)

# 6. Train Model
print("\n🔄 Training XGBoost model...")
try:
    model_pipeline.fit(X_train, y_train_enc)
    print("✅ XGBoost training complete!")
except Exception as e:
    print(f"❌ Training failed: {str(e)}")
    exit()

# 7. Evaluation
# Predict numeric classes (0, 1, 2...)
y_pred_enc = model_pipeline.predict(X_test)

# Convert numeric predictions back to original string labels
y_pred_labels = le.inverse_transform(y_pred_enc)
y_test_labels = le.inverse_transform(y_test_enc)

# Derive binary predictions: If prediction == none_class_index, then 0 (Did not buy), else 1
y_binary_pred = [0 if pred == none_class_index else 1 for pred in y_pred_enc]

print("\n" + "="*60)
print("🚀 XGBoost Model Evaluation")
print("="*60)

# 7.1 Binary Metrics
binary_acc = metrics.accuracy_score(y_binary_test, y_binary_pred)
print(f"\n1. Binary Accuracy (Bought vs Not Bought): {binary_acc:.4f}")
print(metrics.classification_report(y_binary_test, y_binary_pred, zero_division=0))

# 7.2 Multiclass Metrics
multi_acc = metrics.accuracy_score(y_test_enc, y_pred_enc)
print(f"\n2. Multiclass Accuracy (Specific Type): {multi_acc:.4f}")
print(metrics.classification_report(y_test_labels, y_pred_labels, zero_division=0))

# 7.3 Confusion Matrix
print("\nMulticlass Confusion Matrix:")
conf_matrix = metrics.confusion_matrix(y_test_labels, y_pred_labels)
conf_df = pd.DataFrame(conf_matrix, index=le.classes_, columns=le.classes_)
print(conf_df)

# 8. Save Model
# We must save both the Pipeline and the LabelEncoder to decode predictions later
save_obj = {
    'pipeline': model_pipeline,
    'label_encoder': le
}

model_save_path = "model.pkl"
with open(model_save_path, "wb") as f:
    pickle.dump(save_obj, f)
print(f"\n✅ Model and LabelEncoder saved to: {model_save_path}")