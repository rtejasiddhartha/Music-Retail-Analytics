# 🔍 Ad-Hoc Business Analysis Summary

This document summarizes **exploratory (ad-hoc) analysis** performed on the
Music Store database.  
The purpose of this analysis is to **understand business behavior, data realism,
and analytical readiness**, not to enforce constraints or automation.

All queries used here are located in:

sql/07_analysis/ad_hoc_analysis.sql


---

## 🎯 Purpose of Ad-Hoc Analysis

Ad-hoc analysis is used to:
- Explore the dataset freely
- Answer business questions interactively
- Validate realism from a business perspective
- Identify patterns worth formalizing later
- Support reporting, dashboards, and interviews

These queries are **not validation rules** and **not automation logic**.
They are intentionally flexible.

---

## 🎵 Catalog & Content Insights

### Famous Artists Track Coverage
- **2,367 tracks** belong to famous artists
- Tracks span multiple albums and media types
- Provides a rich, reusable reference set for analytics

**Business Meaning**
- Famous artists are well represented
- Enough depth exists for popularity and recommendation analysis
- Catalog is not overly dominated by famous artists

---

### Albums Never Ordered
- **0 albums** have never been ordered

**Interpretation**
- Every album participates in demand
- No dead or disconnected inventory
- All catalog items are analytically usable

This is an intentional design choice for analytics-focused datasets.

---

## 👥 Customer & Geography Insights

### Customers by Country
| Country | Customers |
|------|-----------:|
| Canada | 15,049 |
| United States | 14,951 |

**Interpretation**
- Near-perfect geographic balance
- Enables fair country-level comparisons
- No regional skew

---

### Customer Address Status
| Address Status | Count |
|---------------|------:|
| Active (disabled = 0) | 28,200 |
| Disabled (disabled = 1) | 1,800 |

**Interpretation**
- ~6% disabled addresses
- Represents realistic lifecycle events:
  - relocation
  - invalid addresses
  - account cleanup

---

### Billing vs Shipping Address Usage
| Type | Customers |
|----|----------:|
| Same address | 23,085 |
| Different address | 6,915 |

**Interpretation**
- ~77% use same address
- ~23% use different addresses (gifts, work, alternate locations)
- Matches real e-commerce behavior

---

## 🏭 Vendor & Supply Insights

### Vendors by Country
| Country | Vendors |
|-------|--------:|
| Canada | 130 |
| United States | 70 |

**Interpretation**
- Supplier base is intentionally Canada-heavy
- Enables supply-side geographic analysis
- Useful for vendor risk and sourcing discussions

---

### Vendors with No Invoices
- **0 vendors without invoices**

**Interpretation**
- All vendors are active
- No orphan or unused vendor records
- Clean master data design

---

## 🧠 Overall Observations

| Area | Result |
|----|----|
Catalog participation | All albums ordered |
Customer realism | High |
Geographic balance | Excellent |
Address behavior | Realistic |
Vendor activity | Clean |
Analytics readiness | Strong |

The dataset behaves like a **well-designed retail system**, not a toy dataset.

---

## 🏁 Conclusion

Ad-hoc analysis confirms that:
- The catalog is fully connected to demand
- Customer and address data reflect real usage patterns
- Vendors are active and meaningful
- The dataset supports rich business exploration

This file serves as:
- A sandbox for exploration
- A source of business insights
- A bridge between raw data and formal analytics

Future steps may formalize some of these insights into
dashboards or analytical models, but ad-hoc flexibility
remains intentionally preserved.
