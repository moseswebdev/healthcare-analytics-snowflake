-- =====================================================
-- Healthcare Analytics Data Warehouse - Complete Setup
-- Author: Moses Kiprono
-- Snowflake Data Engineering Professional Certificate
-- =====================================================

-- STEP 1: CREATE INFRASTRUCTURE
-- =====================================================

CREATE DATABASE IF NOT EXISTS HEALTHCARE_DW;
USE DATABASE HEALTHCARE_DW;

CREATE SCHEMA IF NOT EXISTS STAGING;
CREATE SCHEMA IF NOT EXISTS ANALYTICS;
CREATE SCHEMA IF NOT EXISTS UTILS;

-- Create warehouses
CREATE WAREHOUSE IF NOT EXISTS ETL_WH
    WITH WAREHOUSE_SIZE = 'SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;

USE WAREHOUSE ETL_WH;

-- STEP 2: CREATE DIMENSION TABLES
-- =====================================================

USE SCHEMA ANALYTICS;

-- Date Dimension
CREATE OR REPLACE TABLE DIM_DATE (
    date_key NUMBER PRIMARY KEY,
    full_date DATE NOT NULL,
    day_of_week NUMBER,
    day_name VARCHAR(10),
    day_of_month NUMBER,
    month NUMBER,
    month_name VARCHAR(10),
    quarter NUMBER,
    year NUMBER,
    year_month VARCHAR(7)
);

-- Patient Dimension
CREATE OR REPLACE TABLE DIM_PATIENTS (
    patient_key NUMBER AUTOINCREMENT PRIMARY KEY,
    patient_id VARCHAR(50) NOT NULL,
    full_name VARCHAR(200),
    date_of_birth DATE,
    age NUMBER,
    gender VARCHAR(10),
    city VARCHAR(100),
    state VARCHAR(2),
    insurance_provider VARCHAR(100)
);

-- Provider Dimension
CREATE OR REPLACE TABLE DIM_PROVIDERS (
    provider_key NUMBER AUTOINCREMENT PRIMARY KEY,
    provider_id VARCHAR(50) NOT NULL,
    provider_name VARCHAR(100),
    specialty VARCHAR(100),
    years_of_experience NUMBER
);

-- Facility Dimension
CREATE OR REPLACE TABLE DIM_FACILITIES (
    facility_key NUMBER AUTOINCREMENT PRIMARY KEY,
    facility_id VARCHAR(50) NOT NULL,
    facility_name VARCHAR(100),
    facility_type VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(2),
    bed_capacity NUMBER
);

-- Diagnosis Dimension
CREATE OR REPLACE TABLE DIM_DIAGNOSES (
    diagnosis_key NUMBER AUTOINCREMENT PRIMARY KEY,
    diagnosis_code VARCHAR(20) NOT NULL,
    diagnosis_description VARCHAR(500),
    category VARCHAR(100),
    severity VARCHAR(20)
);

-- STEP 3: CREATE FACT TABLE
-- =====================================================

CREATE OR REPLACE TABLE FACT_PATIENT_VISITS (
    visit_key NUMBER AUTOINCREMENT PRIMARY KEY,
    visit_id VARCHAR(50) NOT NULL,
    patient_key NUMBER NOT NULL,
    provider_key NUMBER NOT NULL,
    facility_key NUMBER NOT NULL,
    visit_date_key NUMBER NOT NULL,
    primary_diagnosis_key NUMBER,
    visit_type VARCHAR(50),
    visit_duration_minutes NUMBER,
    total_cost NUMBER(10,2),
    insurance_coverage NUMBER(10,2),
    patient_payment NUMBER(10,2),
    patient_satisfaction_score NUMBER(3,2),
    FOREIGN KEY (patient_key) REFERENCES DIM_PATIENTS(patient_key),
    FOREIGN KEY (provider_key) REFERENCES DIM_PROVIDERS(provider_key),
    FOREIGN KEY (facility_key) REFERENCES DIM_FACILITIES(facility_key),
    FOREIGN KEY (visit_date_key) REFERENCES DIM_DATE(date_key)
);

-- STEP 4: INSERT SAMPLE DATA
-- =====================================================

-- Populate Date Dimension (2024-2026)
INSERT INTO DIM_DATE
SELECT
    TO_NUMBER(TO_CHAR(seq_date, 'YYYYMMDD')) as date_key,
    seq_date as full_date,
    DAYOFWEEK(seq_date) as day_of_week,
    DAYNAME(seq_date) as day_name,
    DAY(seq_date) as day_of_month,
    MONTH(seq_date) as month,
    MONTHNAME(seq_date) as month_name,
    QUARTER(seq_date) as quarter,
    YEAR(seq_date) as year,
    TO_CHAR(seq_date, 'YYYY-MM') as year_month
FROM (
    SELECT DATEADD(day, SEQ4(), '2024-01-01'::DATE) as seq_date
    FROM TABLE(GENERATOR(ROWCOUNT => 1095))
)
WHERE seq_date <= '2026-12-31';

-- Sample Patients
INSERT INTO DIM_PATIENTS (patient_id, full_name, date_of_birth, age, gender, city, state, insurance_provider)
VALUES
('PAT001', 'John Smith', '1980-05-15', 45, 'Male', 'Seattle', 'WA', 'Blue Cross'),
('PAT002', 'Mary Johnson', '1975-08-22', 50, 'Female', 'Portland', 'OR', 'Aetna'),
('PAT003', 'James Williams', '1990-03-10', 35, 'Male', 'San Francisco', 'CA', 'UnitedHealth'),
('PAT004', 'Patricia Brown', '1985-11-30', 40, 'Female', 'Denver', 'CO', 'Cigna'),
('PAT005', 'Robert Jones', '1995-07-18', 30, 'Male', 'Austin', 'TX', 'Blue Cross'),
('PAT006', 'Linda Garcia', '1970-02-25', 55, 'Female', 'Phoenix', 'AZ', 'Medicare'),
('PAT007', 'Michael Davis', '1988-09-12', 37, 'Male', 'Chicago', 'IL', 'Aetna'),
('PAT008', 'Jennifer Miller', '1992-06-08', 33, 'Female', 'Boston', 'MA', 'UnitedHealth'),
('PAT009', 'William Wilson', '1978-12-20', 47, 'Male', 'Miami', 'FL', 'Cigna'),
('PAT010', 'Elizabeth Moore', '1983-04-05', 42, 'Female', 'Atlanta', 'GA', 'Blue Cross');

-- Sample Providers
INSERT INTO DIM_PROVIDERS (provider_id, provider_name, specialty, years_of_experience)
VALUES
('PRV001', 'Dr. Sarah Johnson', 'Family Medicine', 15),
('PRV002', 'Dr. Michael Chen', 'Cardiology', 20),
('PRV003', 'Dr. Emily Rodriguez', 'Surgery', 12),
('PRV004', 'Dr. David Kim', 'Pediatrics', 8),
('PRV005', 'Dr. Lisa Anderson', 'Neurology', 18),
('PRV006', 'Dr. James Taylor', 'Orthopedics', 25),
('PRV007', 'Dr. Maria Santos', 'Internal Medicine', 10),
('PRV008', 'Dr. Thomas White', 'Emergency Medicine', 14);

-- Sample Facilities
INSERT INTO DIM_FACILITIES (facility_id, facility_name, facility_type, city, state, bed_capacity)
VALUES
('FAC001', 'Seattle Medical Center', 'Hospital', 'Seattle', 'WA', 350),
('FAC002', 'Portland Clinic', 'Clinic', 'Portland', 'OR', 25),
('FAC003', 'Bay Area Hospital', 'Hospital', 'San Francisco', 'CA', 500),
('FAC004', 'Denver Urgent Care', 'Urgent Care', 'Denver', 'CO', 15),
('FAC005', 'Austin Specialty Center', 'Specialty Center', 'Austin', 'TX', 100);

-- Sample Diagnoses
INSERT INTO DIM_DIAGNOSES (diagnosis_code, diagnosis_description, category, severity)
VALUES
('I10', 'Essential hypertension', 'Cardiovascular', 'Moderate'),
('E11.9', 'Type 2 diabetes mellitus', 'Endocrine', 'Moderate'),
('J45.909', 'Asthma', 'Respiratory', 'Moderate'),
('M79.3', 'Myalgia', 'Musculoskeletal', 'Mild'),
('R50.9', 'Fever', 'Symptoms', 'Mild'),
('J06.9', 'Upper respiratory infection', 'Respiratory', 'Mild'),
('I25.10', 'Coronary artery disease', 'Cardiovascular', 'Severe'),
('N39.0', 'Urinary tract infection', 'Genitourinary', 'Moderate');

-- Sample Patient Visits
INSERT INTO FACT_PATIENT_VISITS (
    visit_id, patient_key, provider_key, facility_key, visit_date_key, 
    primary_diagnosis_key, visit_type, visit_duration_minutes, 
    total_cost, insurance_coverage, patient_payment, patient_satisfaction_score
)
VALUES
('V0001', 1, 1, 1, 20250115, 1, 'Office Visit', 45, 250.00, 200.00, 50.00, 4.5),
('V0002', 2, 2, 3, 20250116, 7, 'Emergency', 180, 2500.00, 2000.00, 500.00, 4.2),
('V0003', 3, 1, 2, 20250117, 6, 'Follow-up', 30, 150.00, 120.00, 30.00, 4.8),
('V0004', 4, 3, 1, 20250118, 3, 'Surgery', 240, 8500.00, 7650.00, 850.00, 4.9),
('V0005', 5, 4, 4, 20250119, 5, 'Office Visit', 60, 200.00, 160.00, 40.00, 4.6),
('V0006', 6, 5, 3, 20250120, 1, 'Consultation', 90, 400.00, 320.00, 80.00, 4.7),
('V0007', 7, 6, 5, 20250121, 4, 'Office Visit', 45, 275.00, 220.00, 55.00, 4.3),
('V0008', 8, 7, 1, 20250122, 2, 'Annual Physical', 120, 350.00, 350.00, 0.00, 4.9),
('V0009', 9, 8, 4, 20250123, 8, 'Emergency', 90, 1200.00, 960.00, 240.00, 4.1),
('V0010', 10, 1, 2, 20250124, 6, 'Follow-up', 30, 150.00, 120.00, 30.00, 4.8),
('V0011', 1, 2, 3, 20250125, 1, 'Follow-up', 45, 200.00, 160.00, 40.00, 4.6),
('V0012', 3, 3, 1, 20250126, 3, 'Office Visit', 60, 300.00, 240.00, 60.00, 4.5),
('V0013', 5, 4, 2, 20250127, 4, 'Office Visit', 30, 180.00, 144.00, 36.00, 4.7),
('V0014', 7, 5, 3, 20250128, 2, 'Consultation', 75, 380.00, 304.00, 76.00, 4.4),
('V0015', 2, 6, 5, 20250129, 1, 'Follow-up', 40, 220.00, 176.00, 44.00, 4.8);

-- STEP 5: CREATE ANALYTICAL VIEWS
-- =====================================================

-- Complete Visit Details View
CREATE OR REPLACE VIEW VW_VISIT_DETAILS AS
SELECT 
    f.visit_id,
    d.full_date as visit_date,
    p.full_name as patient_name,
    p.age,
    p.gender,
    prov.provider_name,
    prov.specialty,
    fac.facility_name,
    diag.diagnosis_description,
    f.visit_type,
    f.visit_duration_minutes,
    f.total_cost,
    f.patient_satisfaction_score
FROM FACT_PATIENT_VISITS f
JOIN DIM_DATE d ON f.visit_date_key = d.date_key
JOIN DIM_PATIENTS p ON f.patient_key = p.patient_key
JOIN DIM_PROVIDERS prov ON f.provider_key = prov.provider_key
JOIN DIM_FACILITIES fac ON f.facility_key = fac.facility_key
LEFT JOIN DIM_DIAGNOSES diag ON f.primary_diagnosis_key = diag.diagnosis_key;

-- Monthly Summary View
CREATE OR REPLACE VIEW VW_MONTHLY_SUMMARY AS
SELECT 
    d.year_month,
    COUNT(DISTINCT f.visit_id) as total_visits,
    COUNT(DISTINCT f.patient_key) as unique_patients,
    SUM(f.total_cost) as total_revenue,
    AVG(f.total_cost) as avg_visit_cost,
    AVG(f.patient_satisfaction_score) as avg_satisfaction
FROM FACT_PATIENT_VISITS f
JOIN DIM_DATE d ON f.visit_date_key = d.date_key
GROUP BY d.year_month
ORDER BY d.year_month DESC;

-- Provider Performance View
CREATE OR REPLACE VIEW VW_PROVIDER_PERFORMANCE AS
SELECT 
    prov.provider_name,
    prov.specialty,
    COUNT(f.visit_id) as total_visits,
    COUNT(DISTINCT f.patient_key) as unique_patients,
    AVG(f.visit_duration_minutes) as avg_duration,
    AVG(f.patient_satisfaction_score) as avg_satisfaction,
    SUM(f.total_cost) as total_revenue
FROM FACT_PATIENT_VISITS f
JOIN DIM_PROVIDERS prov ON f.provider_key = prov.provider_key
GROUP BY prov.provider_name, prov.specialty
ORDER BY total_visits DESC;

-- STEP 6: VERIFICATION QUERIES
-- =====================================================

SELECT 'Setup Complete!' as STATUS;

-- Check row counts
SELECT 'DIM_PATIENTS' as table_name, COUNT(*) as rows FROM DIM_PATIENTS
UNION ALL SELECT 'DIM_PROVIDERS', COUNT(*) FROM DIM_PROVIDERS
UNION ALL SELECT 'DIM_FACILITIES', COUNT(*) FROM DIM_FACILITIES
UNION ALL SELECT 'DIM_DIAGNOSES', COUNT(*) FROM DIM_DIAGNOSES
UNION ALL SELECT 'FACT_PATIENT_VISITS', COUNT(*) FROM FACT_PATIENT_VISITS;

-- Sample queries
SELECT * FROM VW_VISIT_DETAILS LIMIT 10;
SELECT * FROM VW_MONTHLY_SUMMARY;
SELECT * FROM VW_PROVIDER_PERFORMANCE;

-- =====================================================
-- SUCCESS! Your Healthcare Analytics DW is Ready!
-- =====================================================
