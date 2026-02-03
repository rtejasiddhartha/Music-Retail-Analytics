# 📊 Analytics Views & Reporting Layer

This document describes the **analytical SQL views** created in the Music Store
database and summarizes the **key business insights** derived from them.

These views form the **semantic / BI layer** of the system and are designed
for reporting, dashboards, and downstream analytics.

---

## 🎯 Purpose of Analytics Views

The analytics views are designed to:

- Abstract complex joins and calculations
- Provide business-ready metrics
- Support BI tools (Power BI, Tableau, Looker, Excel)
- Enable repeatable and consistent reporting
- Separate analytics logic from transactional logic (OLTP)

All views are defined in:

sql/07_analysis/customer_and_sales_views.sql


---

## 🧱 Views Overview

### View 1: `Clients_Total_Spent`
**Purpose**
- Calculate total customer spending for March 2023
- Identify high-value customers

**Key Insight**
- Customers above the March average were isolated for segmentation
- Useful for loyalty, retention, and Pareto analysis

**Export**

exports/reference_sheets/
└── view_1_Customers_Spent_above_March_avg.csv


---

### View 2: `TOP_AND_LEAST_SOLD_ALBUMS`
**Purpose**
- Identify top- and least-selling albums for a fixed campaign window
- Time window: March 7–13, 2023

**Key Insight**
- Reveals short-term demand concentration
- Useful for promotion and campaign analysis

**Export**
exports/reference_sheets/
└── view2_HighLow_Selling_Albums.csv


---

### View 3: Hierarchical Customer Counts  
(City → Province → Country)

**Views**
- `Customers_in_City_Count`
- `Customers_in_Province_Count`
- `Customers_in_Country_Count`

**Purpose**
- Provide geographic rollups
- Support drill-down and geo dashboards

**Key Findings**
- Canada: **15,049 customers**
- United States: **14,951 customers**
- Near-perfect geographic balance

**Export**
exports/reference_sheets/
└── view3_counts_by_country_province_city.csv


---

### View 4: `vw_customer_full_profile`
**Purpose**
- Denormalized customer + geography view
- CRM-style reporting

**Key Finding**
- Clean customer-to-address mapping
- Supports regional filtering and customer profiling

**Export**
exports/reference_sheets/
└── view4_Canadian_Customers.csv


---

## 📉 Loss & Margin Analysis (Advanced Analytics)

### View 5: `vw_detailed_loss_orders`
**Purpose**
- Identify order items sold below vendor cost
- Quantify cumulative losses

**Loss Formula**
(unit_price − vendor_price) × quantity_to_buy


---

### 🔴 Top 3 Loss-Making Albums (Cumulative)

| Album | Total Loss |
|-----|-----------:|
| Dark & Wild | -78,521.06 |
| Burning Rooms (Anthology) | -68,702.47 |
| Chromatica | -53,962.02 |

**Interpretation**
- Loss driven by high-volume sales at negative margins
- Represents realistic loss-leader or pricing-lag scenarios

---

### 📆 Year-wise Loss Trend (Top 3 Albums)

| Year | Album | Total Loss |
|----|-----------------------------|-----------:|
| 2022 | Burning Rooms (Anthology) | -21,429.92 |
| 2022 | Dark & Wild | -19,057.13 |
| 2022 | Chromatica | -17,735.17 |
| 2023 | Dark & Wild | -28,009.75 |
| 2023 | Burning Rooms (Anthology) | -20,992.52 |
| 2023 | Chromatica | -19,500.91 |
| 2024 | Dark & Wild | -24,165.92 |
| 2024 | Burning Rooms (Anthology) | -16,587.39 |
| 2024 | Chromatica | -13,580.04 |
| 2025 | Burning Rooms (Anthology) | -9,692.64 |
| 2025 | Dark & Wild | -7,288.26 |
| 2025 | Chromatica | -3,145.90 |

**Interpretation**
- Loss peaks during high-demand years
- Gradual reduction suggests pricing or procurement correction
- Demonstrates realistic margin recovery behavior

---

### 🧾 Loss Orders Summary

| Metric | Value |
|----|----:|
| Unique orders with ≥1 loss item | **2,529** |

**Interpretation**
- Losses are distributed across many orders
- Not caused by isolated anomalies
- Suitable for operational margin analysis

---

## 📁 Exported Reference Data

All CSV outputs generated from analytics views are stored in:
exports/reference_sheets/


### Available Exports
- `view_1_Customers_Spent_above_March_avg.csv`
- `view2_HighLow_Selling_Albums.csv`
- `view3_counts_by_country_province_city.csv`
- `view4_Canadian_Customers.csv`

These files are:
- Derived from views (not raw tables)
- Stable reference snapshots
- Intended for Excel, BI tools, and Python analytics

---

## 🧠 Architectural Significance

This analytics layer demonstrates:

- Clear separation of OLTP and OLAP
- View-based semantic modeling
- Business-driven metrics
- Realistic loss and demand behavior
- Portfolio-grade reporting design

The database now supports:
- Live transactions (orders, inventory)
- Automated logic (triggers)
- Exploratory analysis (ad-hoc SQL)
- Formal analytics & reporting (views)

---

## 🏁 Summary

The analytics views provide a **clean, reusable reporting foundation**.
All derived insights are numerically validated, business-explainable,
and suitable for dashboards, storytelling, and interviews.

This completes the **analytics layer** of the Music Store database.

