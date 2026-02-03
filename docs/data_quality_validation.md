# Data Quality & Integrity Validation (SQL)

## Overview
This document summarizes the **post-load data quality validation** performed on the Music Store Analytics database.  
All checks were executed **after completing data ingestion**, and **no data was modified** during this process.  
The goal is to ensure that the dataset is **structurally sound, logically consistent, and analytics-ready**.

> 📌 **Important**  
> This validation uses **read-only SQL queries only**.  
> No schema changes, triggers, or corrective updates are applied in this phase.

---

## Validation Scope

The validation covers the following core domains:

- Customer & Address Integrity  
- Geographic Consistency (City → Province → Country)  
- Vendor Master Data  
- Artist & Album Consistency  
- Pricing & Inventory Sanity  
- Referential Integrity across keys  

---

## 1. Customer Geography & Address Validation

### Customer Distribution by Country
| Country | Customers |
|------|----------|
| Canada | 15,049 |
| United States | 14,951 |

✔ Balanced and intentional distribution across two countries.

---

### Postal Code Format Validation
| Check | Result |
|----|------|
| Invalid Canadian postal codes | **0** |
| Invalid US ZIP codes | **0** |

✔ All postal codes match expected country-specific formats.

---

### Province / State Distribution (Lowest Counts)
Examples:
| Province / State | Country | Customers |
|-----------------|--------|----------|
| District of Columbia | US | 53 |
| Wyoming | US | 154 |
| Yukon | Canada | 165 |
| Nunavut | Canada | 178 |

✔ Low-population regions intentionally modeled to reflect realistic geographic skew.

---

### Shared Postal Codes
- Maximum customers sharing a postal code: **4**
- Typical range: **3–4 customers**

✔ Acceptable density for urban and apartment-heavy areas.

---

### Address Structure Validation
| Metric | Value |
|------|------|
| Total addresses | 30,000 |
| Addresses with unit / suite | 10,627 |
| % with unit | **35.42%** |

✔ Realistic apartment vs independent housing distribution.

---

### Address Cardinality
| Check | Result |
|----|------|
| Customers with >1 address | **0** |
| Orphan addresses | **0** |
| Invalid billing/shipping references | **0** |

✔ Strong referential integrity maintained.

---

## 2. Customer Profile Validation

| Metric | Result |
|-----|-------|
| Total customers | 30,000 |
| Same billing & shipping address | 23,085 (76.95%) |
| Different billing & shipping address | 6,915 (23.05%) |

✔ Healthy split reflecting real-world ecommerce behavior.

---

### Identity & Contact Validation
| Check | Result |
|----|------|
| Duplicate emails | **0** |
| Duplicate phone numbers | **0** |
| Invalid email formats | **0** |
| Same first & last name | 4 (edge cases) |

✔ Identity fields are clean and reliable.

---

### Age Distribution
| Metric | Value |
|----|------|
| Minimum age | 18 |
| Maximum age | 70 |
| Average age | 43.98 |
| Suspicious ages (<13 or >90) | **0** |

✔ Fully compliant with realistic customer demographics.

---

## 3. Vendor Data Quality Checks

| Metric | Result |
|------|------|
| Total vendors | 200 |
| Active vendors | 120 |
| Inactive vendors | 80 |

✔ Supports lifecycle analysis (active vs dormant suppliers).

---

### Vendor Integrity
| Check | Result |
|----|------|
| Duplicate vendor names | **0** |
| Duplicate vendor phones | **0** |
| Vendors sharing same address | **0** |

✔ Vendor master is clean and uniquely identifiable.

---

### Vendor Geography
| Country | Vendors |
|------|--------|
| Canada | 130 |
| United States | 70 |

✔ Intentionally skewed to test regional supplier dependency.

---

### Vendor Postal Validation
| Check | Result |
|----|------|
| Invalid Canadian vendor postal codes | **0** |
| Invalid US vendor ZIP codes | **0** |

✔ All vendor addresses conform to country standards.

---

## 4. Artist & Album Consistency Checks

### Famous Artists Coverage
| Check | Result |
|----|------|
| Famous artists missing in artist master | **0** |

✔ Full alignment between `famous_artists` and `artist` tables.

---

### Expected vs Actual Album Counts
- Several famous artists intentionally have **fewer albums than expected**
- Used to test:
  - Missing catalog detection
  - Incomplete discography scenarios
  - Data reconciliation logic

✔ This is **intentional and controlled**, not a data defect.

---

### Album Integrity
| Check | Result |
|----|------|
| Duplicate album names under same artist | **0** |
| Unrealistic inventory levels (0 or >1000) | **0** |

✔ Album catalog and inventory levels are well constrained.

---

### Album Price Distribution
| Artist Type | Min | Max | Avg |
|-----------|-----|-----|-----|
| Famous | 6.02 | 19.79 | 13.29 |
| Non-Famous | 5.99 | 19.97 | 12.90 |

✔ Pricing overlaps intentionally to avoid simplistic assumptions in analysis.

---

## Overall Assessment

✅ **All critical data quality checks passed**  
✅ **No referential integrity violations**  
✅ **No invalid formats or duplicates**  
✅ **Edge cases are intentional and documented**  

This dataset is **production-grade for analytics**, suitable for:
- BI dashboards  
- Financial & sales analysis  
- Inventory modeling  
- Data quality demonstrations  
- OLAP-style reporting  

---

## Notes on Synthetic Design
While structurally realistic, this dataset is **fully synthetic** and intentionally includes:
- Skewed geographic distributions
- Incomplete artist catalogs
- Edge cases for validation logic
- Controlled anomalies for analytics testing

These choices enable **robust SQL analysis and scenario-based reasoning** without reflecting any real business or individual.

---

📂 **Location**
- SQL file: `data_quality_validation.sql`
