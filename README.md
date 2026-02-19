# Healthcare Analytics Data Warehouse - snowflake
Production-grade healthcare analytics data warehouse built with Snowflake. Features star schema design, dimensional modeling, and automated ETL. Completed as part of Snowflake Data Engineering Professional Certificate. 


# 🏥 Healthcare Analytics Data Warehouse

[![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)](https://www.snowflake.com/)
[![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.snowflake.com/)

> Production-grade healthcare analytics data warehouse demonstrating enterprise Snowflake data engineering capabilities.

**Built by**: Moses Kiprono  
**Certificate**: [Snowflake Data Engineering Professional](https://www.linkedin.com/learning/certificates/0a76d7ad7e7855e02ecce11dd5f7ef8b0e007e8768822409a24525e647400b32)  
**Completed**: February 9, 2026

---

## 📊 Project Overview

A complete **star schema data warehouse** featuring:
- ✅ 5 dimension tables (Patients, Providers, Facilities, Diagnoses, Date)
- ✅ 1 fact table (Patient Visits with 15+ records)
- ✅ 3 analytical views for business intelligence
- ✅ Sample data spanning 2024-2026
- ✅ Pre-built analytical queries

## 🎯 Skills Demonstrated

- **Dimensional Modeling**: Star schema design (Kimball methodology)
- **Snowflake Platform**: Database design, warehouses, views
- **SQL Development**: Complex queries, joins, aggregations
- **Data Warehouse Architecture**: Staging → Analytics layers
- **Business Intelligence**: Pre-built analytical views

## 🚀 Quick Start

### Prerequisites
- Snowflake account ([Free trial available](https://signup.snowflake.com/))

### Setup (2 minutes)

1. **Login to Snowflake**
2. **Create new worksheet**
3. **Copy & paste** `complete_setup.sql`
4. **Run all** (Ctrl+Enter)
5. **Query your data!**

### Sample Query
```sql
SELECT * FROM HEALTHCARE_DW.ANALYTICS.VW_VISIT_DETAILS;
```

## 📁 Files

| File | Description |
|------|-------------|
| `complete_setup.sql` | Complete database setup (creates all objects) |
| `sample_queries.sql` | 12 analytical queries for demonstrations |

## 📊 Database Schema
```
HEALTHCARE_DW
└── ANALYTICS
    ├── DIM_PATIENTS (10 patients)
    ├── DIM_PROVIDERS (8 providers)  
    ├── DIM_FACILITIES (5 facilities)
    ├── DIM_DIAGNOSES (8 ICD-10 codes)
    ├── DIM_DATE (1,095 dates: 2024-2026)
    ├── FACT_PATIENT_VISITS (15 visits)
    └── Views
        ├── VW_VISIT_DETAILS
        ├── VW_MONTHLY_SUMMARY
        └── VW_PROVIDER_PERFORMANCE
```

## 💡 Sample Queries

### Monthly Revenue Trends
```sql
SELECT * FROM VW_MONTHLY_SUMMARY ORDER BY year_month DESC;
```

### Top Providers
```sql
SELECT * FROM VW_PROVIDER_PERFORMANCE ORDER BY total_visits DESC LIMIT 5;
```

### Patient Visit History
```sql
SELECT 
    patient_name, 
    COUNT(*) as total_visits,
    AVG(patient_satisfaction_score) as avg_satisfaction
FROM VW_VISIT_DETAILS
GROUP BY patient_name;
```

## 🎓 Certificate

This project was completed as part of the **Snowflake Data Engineering Professional Certificate** program.

**Certificate Details**:
- **Course**: Data Engineering Professional Certificate by Snowflake
- **Platform**: LinkedIn Learning
- **Completion Date**: February 9, 2026
- **Duration**: 10 hours 24 minutes
- **Certificate ID**: `0a76d7ad7e7855e02ecce11dd5f7ef8b0e007e8768822409a24525e647400b32`

[View Certificate →](https://www.linkedin.com/learning/certificates/0a76d7ad7e7855e02ecce11dd5f7ef8b0e007e8768822409a24525e647400b32)

## 📈 Key Features

- **Star Schema Design**: Proper dimensional modeling
- **Sample Data**: Realistic healthcare records
- **Analytical Views**: Pre-built business intelligence queries
- **Documentation**: Fully documented SQL with comments
- **Production-Ready**: Follows Snowflake best practices



## 📄 License

MIT License - see LICENSE file for details.

---

⭐ **Star this repository if you find it helpful!**
```

### **Step 3: Add Topics (Tags)**

At the top of your repo, click **"Add topics"** and add:
```
snowflake
data-engineering
sql
data-warehouse
etl
dimensional-modeling
star-schema
healthcare-analytics
portfolio
certificate
