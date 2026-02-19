-- =====================================================
-- Healthcare Analytics - Sample Analytical Queries
-- Author: Moses Kiprono
-- Perfect for demonstrations and portfolio screenshots!
-- =====================================================

USE DATABASE HEALTHCARE_DW;
USE SCHEMA ANALYTICS;

-- =====================================================
-- QUERY 1: Visit Overview Dashboard
-- =====================================================
SELECT 
    visit_id,
    visit_date,
    patient_name,
    provider_name,
    specialty,
    visit_type,
    total_cost,
    patient_satisfaction_score
FROM VW_VISIT_DETAILS
ORDER BY visit_date DESC
LIMIT 20;

-- =====================================================
-- QUERY 2: Monthly Revenue Trends
-- =====================================================
SELECT 
    year_month,
    total_visits,
    unique_patients,
    ROUND(total_revenue, 2) as revenue,
    ROUND(avg_visit_cost, 2) as avg_cost,
    ROUND(avg_satisfaction, 2) as satisfaction
FROM VW_MONTHLY_SUMMARY
ORDER BY year_month DESC;

-- =====================================================
-- QUERY 3: Top Providers by Visit Count
-- =====================================================
SELECT 
    provider_name,
    specialty,
    total_visits,
    unique_patients,
    ROUND(avg_satisfaction, 2) as satisfaction,
    ROUND(total_revenue, 2) as revenue
FROM VW_PROVIDER_PERFORMANCE
ORDER BY total_visits DESC
LIMIT 10;

-- =====================================================
-- QUERY 4: Patient Demographics Analysis
-- =====================================================
SELECT 
    CASE 
        WHEN age < 18 THEN '0-17'
        WHEN age < 35 THEN '18-34'
        WHEN age < 50 THEN '35-49'
        WHEN age < 65 THEN '50-64'
        ELSE '65+'
    END as age_group,
    gender,
    COUNT(*) as patient_count
FROM DIM_PATIENTS
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- =====================================================
-- QUERY 5: Visit Type Distribution
-- =====================================================
SELECT 
    visit_type,
    COUNT(*) as visit_count,
    ROUND(AVG(total_cost), 2) as avg_cost,
    ROUND(AVG(patient_satisfaction_score), 2) as avg_satisfaction,
    ROUND(AVG(visit_duration_minutes), 0) as avg_duration_min
FROM FACT_PATIENT_VISITS
GROUP BY visit_type
ORDER BY visit_count DESC;

-- =====================================================
-- QUERY 6: Cost Analysis by Specialty
-- =====================================================
SELECT 
    prov.specialty,
    COUNT(f.visit_id) as total_visits,
    ROUND(AVG(f.total_cost), 2) as avg_cost,
    ROUND(MIN(f.total_cost), 2) as min_cost,
    ROUND(MAX(f.total_cost), 2) as max_cost
FROM FACT_PATIENT_VISITS f
JOIN DIM_PROVIDERS prov ON f.provider_key = prov.provider_key
GROUP BY prov.specialty
ORDER BY avg_cost DESC;

-- =====================================================
-- QUERY 7: High-Cost Visits (Top 10)
-- =====================================================
SELECT 
    f.visit_id,
    p.full_name as patient,
    prov.provider_name,
    d.full_date as visit_date,
    f.visit_type,
    f.total_cost,
    f.insurance_coverage,
    f.patient_payment
FROM FACT_PATIENT_VISITS f
JOIN DIM_PATIENTS p ON f.patient_key = p.patient_key
JOIN DIM_PROVIDERS prov ON f.provider_key = prov.provider_key
JOIN DIM_DATE d ON f.visit_date_key = d.date_key
ORDER BY f.total_cost DESC
LIMIT 10;

-- =====================================================
-- QUERY 8: Facility Utilization
-- =====================================================
SELECT 
    fac.facility_name,
    fac.facility_type,
    fac.city,
    fac.state,
    COUNT(f.visit_id) as total_visits,
    ROUND(AVG(f.patient_satisfaction_score), 2) as avg_satisfaction
FROM FACT_PATIENT_VISITS f
JOIN DIM_FACILITIES fac ON f.facility_key = fac.facility_key
GROUP BY fac.facility_name, fac.facility_type, fac.city, fac.state
ORDER BY total_visits DESC;

-- =====================================================
-- QUERY 9: Diagnosis Frequency
-- =====================================================
SELECT 
    diag.diagnosis_code,
    diag.diagnosis_description,
    diag.category,
    diag.severity,
    COUNT(f.visit_id) as frequency
FROM FACT_PATIENT_VISITS f
JOIN DIM_DIAGNOSES diag ON f.primary_diagnosis_key = diag.diagnosis_key
GROUP BY diag.diagnosis_code, diag.diagnosis_description, diag.category, diag.severity
ORDER BY frequency DESC;

-- =====================================================
-- QUERY 10: Patient Visit History
-- =====================================================
SELECT 
    p.patient_id,
    p.full_name,
    p.age,
    COUNT(f.visit_id) as total_visits,
    MIN(d.full_date) as first_visit,
    MAX(d.full_date) as last_visit,
    ROUND(SUM(f.total_cost), 2) as lifetime_value,
    ROUND(AVG(f.patient_satisfaction_score), 2) as avg_satisfaction
FROM DIM_PATIENTS p
JOIN FACT_PATIENT_VISITS f ON p.patient_key = f.patient_key
JOIN DIM_DATE d ON f.visit_date_key = d.date_key
GROUP BY p.patient_id, p.full_name, p.age
ORDER BY lifetime_value DESC;

-- =====================================================
-- QUERY 11: Weekend vs Weekday Visits
-- =====================================================
SELECT 
    CASE 
        WHEN d.day_of_week IN (0, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END as day_type,
    COUNT(f.visit_id) as visit_count,
    ROUND(AVG(f.total_cost), 2) as avg_cost,
    ROUND(AVG(f.patient_satisfaction_score), 2) as avg_satisfaction
FROM FACT_PATIENT_VISITS f
JOIN DIM_DATE d ON f.visit_date_key = d.date_key
GROUP BY day_type;

-- =====================================================
-- QUERY 12: Insurance Coverage Analysis
-- =====================================================
SELECT 
    p.insurance_provider,
    COUNT(f.visit_id) as total_visits,
    ROUND(AVG(f.total_cost), 2) as avg_total_cost,
    ROUND(AVG(f.insurance_coverage), 2) as avg_insurance_paid,
    ROUND(AVG(f.patient_payment), 2) as avg_patient_paid,
    ROUND(AVG(f.patient_payment / NULLIF(f.total_cost, 0) * 100), 1) as avg_patient_percentage
FROM FACT_PATIENT_VISITS f
JOIN DIM_PATIENTS p ON f.patient_key = p.patient_key
GROUP BY p.insurance_provider
ORDER BY total_visits DESC;

-- =====================================================
-- END OF SAMPLE QUERIES
-- =====================================================

-- Take screenshots of these results for your portfolio!
