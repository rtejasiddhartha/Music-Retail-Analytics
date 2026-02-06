# 🎵 Music Retail Analytics — SQL Data Warehouse Project

A complete **end-to-end SQL-based Data Warehouse & Analytics system** built using **MySQL**, covering **OLTP → OLAP → Business Analytics** with a strong focus on **data modeling, data quality, and advanced SQL analytics**.

This project simulates a **music retail business** and is designed primarily for **learning, demonstration, and interview discussion**, not for real-world commercial reporting.

---

## 📌 Project Overview

This repository demonstrates how a real-world analytics system can be built **from scratch**, starting with:

- ER modeling
- Normalized transactional schema (OLTP)
- Dimensional modeling (OLAP)
- Data validation & sanity checks
- Advanced SQL analytics
- Business insight documentation

> 📘 A **much more detailed and elaborated business & analytics explanation** is available here:  
> 👉 **[`docs/business_overview.md`](docs/business_overview.md)**  
>  
> The root README is intentionally kept concise to avoid visual clutter.

---

## ⚠️ Important Disclaimers (Please Read)

### 1️⃣ Synthetic Data Disclaimer

- All transactional data (orders, revenue, profit, losses, customer behavior) is **purely synthetic**
- The dataset is **intentionally designed** to surface edge cases, anomalies, and analytical scenarios
- This data **does not represent real sales performance** of any business or artist

### 2️⃣ Use of Real Artist / Album Names

- Artist names, albums, and tracks include **partially real-world entities**
- These are used **only to make the project realistic and engaging**
- Their inclusion **does not imply actual sales, profit, loss, or business performance**
- No commercial use, endorsement, or monetization is intended

### 3️⃣ Unrealistic or Extreme Insights (Intentional)

You may observe insights such as:

- Non-famous artists generating more profit than famous artists
- Famous artists (e.g., BTS, Lady Gaga) showing **large negative profits**
- Extremely high losses or margins in some scenarios

✅ **These are intentional outliers**, designed to demonstrate:

- Licensing cost impact
- Strategic loss-leader scenarios
- Margin erosion due to procurement or royalty models
- Why analytics must investigate *why* numbers look abnormal

> These scenarios are **educational simulations**, not real-world claims.

---

## 🏗️ Project Structure

Music-Retail-Analytics/
│
├── docs/ # Business & analytics documentation
│ ├── business_overview.md # Deep, end-to-end business explanation
│ ├── Data_Model_Explanation.md
│ ├── financial_analysis.md
│ ├── profit_revenue_contribution.md
│ ├── operational_metrics.md
│ ├── geographic_channel_analysis.md
│ ├── sanity_checks.md
│ ├── data_quality_validation.md
│ └── ...
│
├── sql/
│ ├── 01_schema/ # Table definitions & constraints
│ ├── 02_master_data/ # Static & reference data
│ ├── 03_transaction_data/ # Orders, invoices, order items
│ ├── 04_business_logic/ # Triggers & rules
│ ├── 05_analytical_views/ # OLAP-style analytical queries
│ ├── 06_advanced_sql/ # Window functions, CTEs, dimensions
│ └── 07_sql_analysis/ # Phase-wise analytics
│
├── exports/
│ └── reference_sheets/ # CSV outputs for inspection & sharing
│
└── README.md # This file


---

## 🧠 What This Project Covers

### 🔹 Data Analytics Concepts (Approx. Coverage)

- Data Modeling & ER Design — **100%**
- Dimensional Modeling (Star-style) — **90%**
- Business KPI Design — **85%**
- Customer Analytics & CLV — **80%**
- Revenue, Profit & Margin Analysis — **85%**
- Channel & Geographic Analysis — **80%**
- Data Quality & Validation — **90%**
- Sanity Checks & Anomaly Detection — **85%**

---

### 🔹 SQL Concepts Covered (Approx. Coverage)

✔ Core SQL  
✔ Joins (Inner, Left, Self, Semi, Anti)  
✔ Aggregations & Conditional Logic  
✔ Window Functions  
✔ Ranking & Segmentation  
✔ Running Totals & Moving Averages  
✔ CTEs (Single & Multi-step Pipelines)  
✔ Correlated & Scalar Subqueries  
✔ EXISTS / NOT EXISTS  
✔ Date & Time Analytics  
✔ Dimensional Tables (Date, Customer, Album)  
✔ Data Validation Queries  
✔ Query Optimization Patterns  

> 📊 Overall SQL depth: **Advanced / Production-oriented**

---

## 🧱 OLTP vs OLAP in This Project

**OLTP (Transactional Layer):**
- Orders, order items, invoices
- Normalized schema
- Insert-heavy, constraint-driven

**OLAP (Analytical Layer):**
- Dimensional tables (`dim_date`, `dim_customer`, `dim_album`)
- Analytical queries & reporting views
- Read-heavy, aggregation-focused

This separation mirrors **real-world data warehouse architecture**.

---

## 🎯 Why This Project Is Valuable

This is **not** a dashboard-first or ML-first project.

Instead, it demonstrates:

- How analytics systems are *actually built*
- How SQL alone can power deep business insights
- How to reason about bad data, anomalies, and edge cases
- How to design queries that executives care about

It is especially valuable for roles involving:
- Data Analysis
- Analytics Engineering
- BI Engineering
- SQL-heavy backend analytics
- Interview case studies & system walkthroughs

---

## 📘 Want the Full Story?

For a **complete, detailed, business-style explanation** including:
- Business interpretation
- Strategic insights
- Executive KPIs
- Growth & risk assessment

👉 Read **[`business_overview.md`](business_overview.md)**

---

## ✅ Final Note

This project was intentionally designed to:

✔ Cover **most SQL concepts end-to-end**  
✔ Simulate **real analytical complexity**  
✔ Encourage **critical thinking over blind reporting**  

> *It is a learning-first, system-building project — not a sales prediction model.*

---

**Author:** Tejas Siddhartha  
**Database:** MySQL  
**Focus:** SQL, Analytics, Data Warehousing

