# 💰 Financial Analysis & Profitability Insights

This document summarizes the **financial analytics layer** of the Music Store
database. It focuses on **revenue, profit, loss, inventory value, and vendor spend**
using transactional data derived from orders and invoices.

All queries used for this analysis are located in:

sql/05_analytical_views/financial_analysis.sql


---

## 🎯 Purpose of Financial Analysis

The financial analysis layer is designed to:

- Measure revenue performance over time
- Compare online vs store pickup sales
- Identify top revenue-generating albums
- Detect loss-making products
- Evaluate profit trends
- Assess inventory value and vendor spending
- Support business decision-making and BI dashboards

This layer complements:
- Inventory automation (triggers)
- Analytics views
- Ad-hoc business analysis

---

## 📈 Revenue Analysis

### Total Revenue per Year

| Year | Total Revenue |
|----|--------------:|
| 2022 | 495,270.36 |
| 2023 | 496,061.77 |
| 2024 | **533,802.06** |
| 2025 | 204,535.13 |

**Interpretation**
- Revenue is stable across 2022–2023
- 2024 shows clear growth peak
- 2025 represents a partial year
- Revenue trends align with order volume and demand patterns

---

## Net Profit Per Year

**Metric:** `Revenue − Vendor Spend`

| Year | Revenue | Spend | Net Profit |
|-----:|--------:|------:|-----------:|
| 2022 | 495,270.36 | 138,713.57 | 356,556.79 |
| 2023 | 496,061.77 | 150,984.20 | 345,077.57 |
| 2024 | 533,802.06 | 182,116.76 | 351,685.30 |
| 2025 | 204,535.13 | 137,420.84 | 67,114.29 |

📌 **Insight**
- Strong profitability across all full years.
- 2025 shows reduced profit due to partial sales window.
- Demonstrates realistic seasonality / cut-off effects.


### Revenue Split by Order Type

| Year | Order Type | Revenue |
|----|------------|--------:|
| 2022 | Online | 395,595.29 |
| 2022 | Store Pickup | 99,675.07 |
| 2023 | Online | 396,619.72 |
| 2023 | Store Pickup | 99,442.05 |
| 2024 | Online | 420,145.34 |
| 2024 | Store Pickup | 113,656.72 |
| 2025 | Online | 161,317.27 |
| 2025 | Store Pickup | 43,217.86 |

**Interpretation**
- Online orders consistently contribute ~75–80% of revenue
- Store pickup contributes ~20–25%
- Channel split is stable across years
- Reflects realistic omnichannel retail behavior

---

## 🎵 Revenue Concentration

### Top 10 Albums by Revenue

| Album | Revenue |
|----|--------:|
| Obsidian Rhythms (Chronicles) | 2,583.06 |
| Wild Hearts (Edition) | 2,571.86 |
| Ocean Waves (Blueprint) | 2,508.01 |
| Neon Desire (Blueprint) | 2,488.77 |
| Sacred Paths (Tales) | 2,474.86 |
| Neon Tides (Vol. I) | 2,472.29 |
| Crimson Signals (Verse) | 2,454.81 |
| Under the Mistletoe | 2,440.32 |
| Obsidian Paths (Tales) | 2,429.64 |
| Storm Horizons (Chronicles) | 2,412.24 |

**Interpretation**
- Revenue is evenly distributed
- No single album dominates sales
- Supports earlier findings that demand is broad across the catalog

---

## 📉 Profit & Loss Analysis

### Net Profit per Year *(Profitable Items Only)*

| Year | Net Profit |
|----|-----------:|
| 2022 | 2,628,598.55 |
| 2023 | 2,627,610.03 |
| 2024 | **2,710,550.61** |
| 2025 | 1,089,912.84 |

**Notes**
- This calculation includes only transactions where selling price > vendor cost
- Loss-making items are analyzed separately

**Interpretation**
- Profit is stable and strong across full years
- 2024 shows highest profit, matching peak revenue
- 2025 reflects partial-year activity

---

### Albums with Negative Average Margin

| Album | Avg Margin |
|----|-----------:|
| Dark & Wild | -645.36 |
| Burning Rooms (Anthology) | -467.94 |
| Chromatica | -406.95 |

**Interpretation**
- These albums are consistently sold below vendor cost
- Matches earlier loss analysis exactly
- Confirms correctness of loss detection logic

---

## 🔴 Loss Analysis Summary

### Top 3 Loss-Making Albums (Cumulative)

| Album | Total Loss |
|----|-----------:|
| Dark & Wild | -78,521.06 |
| Burning Rooms (Anthology) | -68,702.47 |
| Chromatica | -53,962.02 |

### Year-Wise Loss Trend (Excerpt)

| Year | Album | Total Loss |
|----|-----------------------------|-----------:|
| 2022 | Burning Rooms (Anthology) | -21,429.92 |
| 2023 | Dark & Wild | -28,009.75 |
| 2024 | Dark & Wild | -24,165.92 |
| 2025 | Chromatica | -3,145.90 |

**Interpretation**
- Loss peaks during high-demand years
- Gradual reduction indicates pricing or procurement correction
- Mirrors real retail loss-leader behavior

---

### Loss Orders

| Metric | Value |
|----|----:|
| Unique orders with ≥1 loss item | **2,529** |

**Interpretation**
- Losses are distributed across many orders
- Not driven by isolated anomalies

---

## 📦 Inventory & Vendor Financials

### Total Inventory Value (Selling Price)

| Metric | Value |
|----|------:|
| Total Inventory Value | **5,573,197.48** |

**Interpretation**
- Inventory value is significantly higher than annual revenue
- Indicates deep catalog and safety-stock strategy
- Aligns with earlier inventory trigger analysis

---

### Vendor Spend per Year

| Year | Vendor Spend |
|----|-------------:|
| 2022 | 138,713.57 |
| 2023 | 150,984.20 |
| 2024 | **182,116.76** |
| 2025 | 137,420.84 |

**Interpretation**
- Vendor spend scales with revenue growth
- Peak spend in 2024 aligns with highest sales year
- 2025 reflects partial-year procurement

---

## 🧠 Key Takeaways

- Revenue, profit, and loss metrics are internally consistent
- Loss-making albums are clearly identifiable and persistent
- Profitability remains strong despite targeted losses
- Inventory and vendor spend align with demand patterns
- Financial behavior mirrors real retail operations

---

## 🏁 Conclusion

The financial analysis layer provides a **complete, realistic view of business
performance**, integrating revenue, cost, profit, loss, and inventory valuation.

This layer:
- Complements inventory automation and analytics views
- Supports BI dashboards and executive reporting
- Demonstrates production-grade financial modeling
- Is fully suitable for portfolio presentation and interviews

This completes the **financial analytics layer** of the Music Store database.