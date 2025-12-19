# InsureAI System - Installation & Running Guide

This project is an End-to-End Insurance System integrating a Flask Web App, MySQL Database, and Machine Learning models. Follow the steps below to set up and run the system.

## 🛠️ Prerequisites

Before you begin, ensure your system has:

1.  **Python 3.8 or higher**
2.  **MySQL Server 8.0 or higher**

---

## 🚀 Installation

### Step 1: Get Code & Install Dependencies

1.  Download or clone the repository to your local machine:

    ```bash
    cd DB-Project-Final
    ```

2.  Install the required Python libraries:
    ```bash
    pip install -r requirements.txt
    ```
    _(Includes: Flask, pandas, scikit-learn, xgboost, mysql-connector-python)_

### Step 2: Database Configuration (Crucial)

1.  **Initialize Database Schema**:
    Log in to your MySQL database and run the provided SQL script to create the database and tables:

    ```bash
    # Command Line Method (requires MySQL root password)
    mysql -u root -p < sql/schema.sql
    ```

    _Alternatively, you can open `sql/schema.sql` in MySQL Workbench and execute it._

2.  **Update Connection Settings**:
    Open the `database.py` file in the project root. You **MUST** update the password to match your local MySQL setup:
    ```python
    # File: database.py
    db_config = {
        'host': 'localhost',
        'database': 'EnterpriseInsuranceDB',
        'user': 'root',
        'password': 'YOUR_MYSQL_PASSWORD' # <--- UPDATE THIS
    }
    ```

---

## ▶️ How to Run

### 1. Initialize the AI Model

Before starting the web server, run the training script once to generate the initial machine learning model file (`.pkl`):

```bash
python train_model.py
```

Upon success, you should see a message like: `✅ Model ... saved to models/...`

### 2. Start the Web Application

Run the main Flask application:

```bash
python app.py
```

### 3. Access the System

Open your web browser and navigate to: http://127.0.0.1:5000

## 🧪 System Walkthrough (Verification)

1. Add Client (AI Inference): Click "Add New Client" on the dashboard. Enter client details (e.g., Age: 35, Income: 60000). Upon submission, the system will immediately display an AI Recommendation.

2. Buy Policy (Generate Ground Truth): In the client list, click the "Buy Policy" button for a client. Select the product the client actually purchased and save. This labels the data as "Ground Truth."

3. Trigger Auto-Retrain: Once you record enough new purchases (default threshold is 5 records), the system automatically triggers the background retraining pipeline. You will see a log message in your terminal: `⚡ Auto-Retrain Triggered!`.
