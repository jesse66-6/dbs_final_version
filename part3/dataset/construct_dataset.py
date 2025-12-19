import pandas as pd
import numpy as np
from faker import Faker
import random

# Initialize Faker and random seeds for reproducibility
fake = Faker()
random.seed(42)
np.random.seed(42)

data = []

INSURANCE_TYPES = ['Life', 'A&H', 'FSA', 'No_Insurance']
# Base weights for each category
BASE_WEIGHTS = {
    'Life': 22,
    'A&H': 28,
    'FSA': 25,
    'No_Insurance': 25
}

# Generate 10,000 rows of data
for i in range(1, 10001):
    # 1. Feature Generation (Logic unchanged)
    age = int(np.random.normal(42, 14))
    age = max(18, min(85, age))
    
    gender = random.choice(['Male', 'Female'])
    
    edu_levels = ['High School', 'Associate', 'Bachelor', 'Master', 'PhD', 'Other']
    edu_weights = [0.25, 0.15, 0.3, 0.18, 0.08, 0.04]
    education = random.choices(edu_levels, weights=edu_weights)[0]
    
    # Marital status logic based on age
    if age < 25:
        marital = random.choices(['Single', 'Married'], weights=[0.95, 0.05])[0]
    elif age < 60:
        marital = random.choices(['Single', 'Married', 'Divorced'], weights=[0.15, 0.7, 0.15])[0]
    else:
        marital = random.choices(['Married', 'Divorced', 'Widowed'], weights=[0.35, 0.15, 0.5])[0]
        
    # Dependents logic based on marital status and age
    dependents = 0
    if marital == 'Married' and 28 <= age <= 55:
        dependents = random.choices([1, 2, 3, 4], weights=[0.25, 0.35, 0.25, 0.15])[0]
    elif marital == 'Single' and age < 40:
        dependents = 0
    else:
        dependents = random.choices([0, 1, 2], weights=[0.7, 0.2, 0.1])[0]
        
    # Income calculation logic
    base_income = 25000
    age_bonus = (age - 18) * 1200
    edu_bonus_map = {
        'High School': 0, 'Associate': 8000, 'Bachelor': 30000, 
        'Master': 60000, 'PhD': 90000, 'Other': 5000
    }
    income = base_income + age_bonus + edu_bonus_map[education]
    income = income * np.random.uniform(0.7, 1.4)
    income = round(income, 2)

    # 2. Target Label Generation (Core fix: Ensure weights are non-negative)
    weights = BASE_WEIGHTS.copy()
    
    # --- Logic A: Life Insurance (Fixed subtraction issue by using "no bonus" instead of "penalty") ---
    if dependents == 1:
        weights['Life'] += 50
    elif dependents == 2:
        weights['Life'] += 80
    elif dependents >= 3:
        weights['Life'] += 150
    if marital == 'Married' and 30 <= age <= 55:
        weights['Life'] += 60
    # Fix: Bonus only if income >= 60k, no bonus (instead of subtraction) if lower
    if income > 60000 and income < 100000:
        weights['Life'] += 40
    # Removed subtraction logic: elif income < 35000: weights['Life'] -= 50

    # --- Logic B: A&H Insurance (Accident & Health) ---
    if age > 55:
        weights['A&H'] += 70
    elif age > 65:
        weights['A&H'] += 120
    if gender == 'Male' and marital == 'Single' and 25 <= age <= 45:
        weights['A&H'] += 80
    if income > 80000:
        weights['A&H'] += 50

    # --- Logic C: FSA (Flexible Spending Account / Investment-linked) ---
    if education == 'Master':
        weights['FSA'] += 80
    elif education == 'PhD':
        weights['FSA'] += 150
    if income > 100000:
        weights['FSA'] += 70
    elif income > 120000:
        weights['FSA'] += 120
    if 25 <= age <= 45:
        weights['FSA'] += 50

    # --- Logic D: No_Insurance ---
    if income < 30000:
        weights['No_Insurance'] += 100
    elif income < 25000:
        weights['No_Insurance'] += 180
    if 18 <= age < 25:
        weights['No_Insurance'] += 90
    if dependents == 0 and marital == 'Single' and age < 35:
        weights['No_Insurance'] += 80

    # ========== Critical Fix 1: Force all weights to be non-negative (Safety net) ==========
    weights = {k: max(0, v) for k, v in weights.items()}  # Ensure no negative weights

    # --- Resolve Weight Conflicts (Boost the leading category) ---
    max_weight = max(weights.values())
    max_type = [k for k, v in weights.items() if v == max_weight][0]
    weights[max_type] *= 1.6

    # --- Probability Sampling (Ensure probabilities are non-negative and sum to 1) ---
    choices = list(weights.keys())
    probs = list(weights.values())
    total_weight = sum(probs)
    
    # ========== Critical Fix 2: Handle edge case where total weight is 0 (Avoid division by zero) ==========
    if total_weight == 0:
        norm_probs = [1/len(choices)] * len(choices)  # Uniform distribution
    else:
        norm_probs = [p / total_weight for p in probs]
    
    selected_insurance = np.random.choice(choices, p=norm_probs)
    
    # --- Noise Injection (Add randomness if top choices are close) ---
    sorted_probs = sorted(norm_probs, reverse=True)
    if sorted_probs[0] - sorted_probs[1] < 0.25 and random.random() < 0.03:
        selected_insurance = random.choice(INSURANCE_TYPES)

    # Determine Target Labels
    bought_flag = 0 if selected_insurance == 'No_Insurance' else 1
    final_type = selected_insurance

    data.append([ 
        age, gender, marital, income, education, dependents,
        bought_flag, final_type
    ])

# Export to CSV
df = pd.DataFrame(data, columns=[ 
    'Age', 'Gender', 'MaritalStatus', 'AnnualIncome', 'EducationLevel', 'NumberOfDependents',
    'Target_BoughtInsurance', 'Target_InsuranceType'
])
csv_filename = 'customer_insurance_dataset.csv'
df.to_csv(csv_filename, index=False)

# Print Category Distribution
print(f"Successfully generated dataset: {csv_filename}")
print("-" * 30)
print("Label Distribution:")
dist = df['Target_InsuranceType'].value_counts(normalize=True).round(3)
for cls, ratio in dist.items():
    print(f"{cls}: {ratio*100:.1f}%")