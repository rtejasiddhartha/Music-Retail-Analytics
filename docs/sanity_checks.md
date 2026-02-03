# Sanity Checks — High-Level Business Validation

## Overview

This document describes the **sanity checks** executed after data ingestion and before deep analytics or reporting.

Sanity checks are **lightweight, business-oriented validations** designed to answer one core question:

> **“Does the data behave reasonably at a high level?”**

They do **not** attempt to prove data correctness at a granular level (that is handled by Data Quality Validation).  
Instead, they act as a **quick safety net** to catch obvious red flags early.

---

## How Sanity Checks Differ from Data Quality Checks

| Aspect | Sanity Checks | Data Quality Validation |
|------|---------------|-------------------------|
| Purpose | Business reasonableness | Structural & referential correctness |
| Depth | High-level | Deep & exhaustive |
| Audience | Analysts, stakeholders | Data engineers, DB designers |
| Focus | Orders, revenue, inventory, flow | Keys, formats, duplicates, constraints |
| Failure Meaning | “Something feels off” | “Data is invalid or broken” |

> **Rule of thumb:**  
> - If a check fails → investigate before analytics  
> - If a data quality check fails → fix data before *anything*

---

## Sanity Check Categories & Results

---

### 1. Orders Exist Across All Years

**Purpose**  
Ensures the dataset covers all expected business years and no year is accidentally missing.

**Result**
- Orders present for: **2022, 2023, 2024, 2025**
- No missing years detected

This confirms the dataset is suitable for **year-over-year analysis**.

---

### 2. Overall Revenue vs Vendor Spend

**Purpose**  
Validates that customer revenue and vendor procurement spend are within a **reasonable magnitude** and direction.

**Result**
- Total Revenue: **4,767,358.10**
- Total Vendor Spend: **7,134,211.42**

**Interpretation**
- Vendor spend exceeding revenue is **intentional in this synthetic dataset**
- Used to simulate **loss-heavy scenarios**, long-term inventory investment, or pricing stress tests

This check ensures **values are realistic enough to analyze**, not that the business is profitable.

---

### 3. Negative Inventory Check

**Purpose**  
Ensures no album has a negative inventory balance, which would indicate transactional corruption.

**Result**
- Negative inventory records: **0**

Inventory logic is intact.

---

### 4. Order Type Distribution

**Purpose**  
Validates that order channels are populated and proportionally reasonable.

**Result**
- Online Orders: **49,185**
- Store Pickup Orders: **13,315**

**Interpretation**
- Online dominates as expected in modern retail models
- Store pickup remains a significant secondary channel

Confirms **channel mix realism**.

---

### 5. Customers Without Orders

**Purpose**  
Identifies customers who exist in the system but never placed an order.

**Result**
- Customers without orders: **3,736**

**Interpretation**
This is an **expected edge case**, commonly caused by:
- Account creation without checkout
- Abandoned carts
- Promotional or test accounts

This validates customer lifecycle realism rather than indicating an error.

---

## Why These Checks Matter

Sanity checks ensure:

- No empty time ranges
- No impossible inventory states
- No missing operational flows
- No obviously broken financial magnitudes

They provide **confidence to proceed** with:
- Financial analysis
- Profit & loss modeling
- Customer behavior analytics
- Executive dashboards

---

## Relationship to Other Validation Layers

This project follows a **layered validation approach**:

1. **Schema & Constraints** → Database design
2. **Data Quality Validation** → Structural correctness
3. **Sanity Checks (this file)** → Business reasonableness
4. **Analytics & Reporting** → Insights & storytelling

Each layer serves a **distinct purpose** and should not be merged.

---

## Final Note

All sanity checks passed successfully.

The dataset behaves consistently, predictably, and intentionally — making it safe for advanced analytics, even when modeling **outliers, losses, and stress scenarios**.

---

**File:** `sanity_checks.sql`  
