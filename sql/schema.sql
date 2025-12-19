-- Reset Database (Ensure a clean environment)
DROP DATABASE IF EXISTS EnterpriseInsuranceDB;

CREATE DATABASE EnterpriseInsuranceDB;

USE EnterpriseInsuranceDB;

-- =============================================
-- 1. Product Dimension Table
-- Stores static details about insurance products
-- =============================================
CREATE TABLE Insurance_Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL UNIQUE,
    base_premium DECIMAL(10, 2) NOT NULL,
    risk_category VARCHAR(50) DEFAULT 'Standard',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Pre-load Data (Must match the ML Model's LabelEncoder classes)
INSERT INTO
    Insurance_Product (product_name, base_premium)
VALUES ('No_Insurance', 0.00),
    ('Life', 1500.00), -- Matches 'Life' in CSV
    ('FSA', 500.00), -- Matches 'FSA' (Flexible Spending Account) in CSV
    ('A&H', 800.00);
-- Matches 'A&H' (Accident & Health) in CSV

-- =============================================
-- 2. Core Client Table (OLTP Core)
-- Contains Client Demographics (ML Features) + Ground Truth
-- =============================================
CREATE TABLE Insured_Client (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,

-- ML Feature Fields
age INT NOT NULL CHECK (
    age > 0
    AND age < 120
),
gender ENUM('Male', 'Female', 'Other') NOT NULL,
marital_status VARCHAR(50),
education_level VARCHAR(50),
annual_income DECIMAL(15, 2) NOT NULL,
number_of_dependents INT DEFAULT 0,

-- Key Field: Ground Truth for End-to-End Retraining
-- Populated when a client actually buys a policy
actual_product_bought VARCHAR(100) DEFAULT NULL,

-- Metadata & Governance
data_source VARCHAR(50) DEFAULT 'Web_Form',
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

-- Optimization: Indexes for frequent queries
INDEX idx_demographics (age, annual_income),
    INDEX idx_status (marital_status, education_level)
);

-- =============================================
-- 3. Insights Table (Denormalization)
-- Stores prediction results to avoid re-calculation (Read-Heavy optimization)
-- =============================================
CREATE TABLE Client_Insights (
    insight_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,

-- Computed Field
income_per_dependent DECIMAL(15, 2),

-- Prediction Results
predicted_product_id INT,
    model_version VARCHAR(50),
    prediction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (client_id) REFERENCES Insured_Client(client_id) ON DELETE CASCADE,
    FOREIGN KEY (predicted_product_id) REFERENCES Insurance_Product(product_id)
);

-- =============================================
-- 4. Policy Transaction Table (Fact Table)
-- Stores actual sales records. Uses Partitioning for performance.
-- =============================================
CREATE TABLE Insurance_Policy (
    policy_id INT NOT NULL AUTO_INCREMENT,
    client_id INT NOT NULL,
    product_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    premium_amount DECIMAL(10, 2),
    status ENUM('Active', 'Expired', 'Cancelled') DEFAULT 'Active',

-- Partition key (start_date) must be part of the Primary Key
PRIMARY KEY (policy_id, start_date),
    INDEX idx_client_policy (client_id)
)
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p_history VALUES LESS THAN (2023),
    PARTITION p_2023 VALUES LESS THAN (2024),
    PARTITION p_2024 VALUES LESS THAN (2025),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- =============================================
-- 5. Model Governance Registry (DIKW)
-- Tracks AI model versions, accuracy, and status
-- =============================================
CREATE TABLE Model_Registry (
    model_id INT AUTO_INCREMENT PRIMARY KEY,
    version VARCHAR(100) NOT NULL, -- e.g., 20251219_v1
    file_path VARCHAR(255) NOT NULL, -- e.g., models/model_20251219_v1.pkl
    training_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    accuracy_score DECIMAL(5, 4),
    dataset_rows INT, -- Number of rows used for training
    status ENUM('Active', 'Archived') DEFAULT 'Active'
);