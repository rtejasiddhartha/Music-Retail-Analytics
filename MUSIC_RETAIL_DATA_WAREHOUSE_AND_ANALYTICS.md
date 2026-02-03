# Music Retail Data Warehouse & Analytics System

## 📌 Purpose of This Document

This document is a **comprehensive business and analytics explanation** of the project. It is intentionally more detailed than a typical `README.md` and is designed for:

* Business case study documentation
* MBA-style analysis
* Interview deep-dives
* Analytics storytelling
* Long-term project reference

> ⚠️ This is **not** the root README. This file explains the *business, data model, analytics, and insights end-to-end*.

---

# 🏢 Business Overview

**Industry:** Music Retail
**Customer Type:** B2C
**Geographic Footprint:** 2 Countries, Multi-province, Multi-city
**Stores:** 15 physical pickup locations

### Business Classification

✅ **Omnichannel Digital Music Retailer with Integrated Supply Chain**

This business:

* Sells directly to customers (not B2B distribution)
* Operates primarily online
* Uses physical stores for pickup & fulfillment
* Manages vendors and procurement internally

---

All metrics, KPIs, and business insights documented in this report are derived directly from the SQL queries contained in 
07_sql_analysis/Phase_1_to_9_analytics.sql

---

# 🧠 PHASE 1 — Business Structure (Data Foundation)

### Database Scale

| Entity            |   Count |
| ----------------- | ------: |
| Tables            |      19 |
| Albums            |   1,163 |
| Artists           |   1,000 |
| Tracks            |   7,200 |
| Genres            |      10 |
| Media Types       |       5 |
| Vendors           |     200 |
| Stores            |      15 |
| Cities            |     323 |
| Provinces         |      64 |
| Countries         |       2 |
| Customers (Total) |  30,000 |
| Orders            |  62,500 |
| Order Items       | 134,383 |
| Invoices          |   7,200 |
| Invoice Items     |  32,000 |

### Interpretation

This is a **medium-scale, enterprise-grade retail dataset** with full coverage of:

* Sales
* Customers
* Inventory
* Vendors
* Geography

---

# 💰 PHASE 2 — Sales Performance

### Core Metrics

| Metric              |         Value |
| ------------------- | ------------: |
| Total Revenue       | $1,729,669.32 |
| Total Orders        |        62,500 |
| Total Order Items   |       134,383 |
| Average Order Value |        $31.12 |
| Avg Items per Order |          2.89 |

### Revenue by Year

| Year  |    Revenue | Orders |
| ----- | ---------: | -----: |
| 2022  | 495,270.36 | 17,396 |
| 2023  | 496,061.77 | 17,524 |
| 2024  | 533,802.06 | 20,300 |
| 2025* | 204,535.13 |  7,280 |

*2025 is a partial year

### Insight

* Stable foundation in 2022–23
* Clear growth inflection in 2024
* Growth driven by **volume**, not price inflation

---

# 📦 PHASE 3 — Inventory Movement

| Metric                 |    Value |
| ---------------------- | -------: |
| Units Sold             |  160,499 |
| Units Procured         |   59,246 |
| Net Inventory Movement | -101,253 |

### Key Insight

This confirms a **digital / license-based inventory model** with minimal physical stock dependency.

* Fast-moving products
* Dead stock identified
* Lean inventory strategy

---

# 🏪 PHASE 4 — Channel & Store Analysis

### Channel Split (Orders)

| Channel      | Orders |     % |
| ------------ | -----: | ----: |
| Online       | 49,185 | 78.7% |
| Store Pickup | 13,315 | 21.3% |

### Channel Split (Revenue)

| Channel      |      Revenue |      % |
| ------------ | -----------: | -----: |
| Online       | 1,373,677.62 | 79.42% |
| Store Pickup |   355,991.70 | 20.58% |

### Insight

* Digital-first revenue model
* Physical stores act as fulfillment & trust hubs

---

# 👥 PHASE 5 — Customer Analytics

| Metric                |  Value |
| --------------------- | -----: |
| Active Customers      | 26,264 |
| Repeat Customers      | 18,576 |
| Repeat Rate           |  70.7% |
| Avg Orders / Customer |   2.38 |
| Avg CLV               | $68.29 |

### Insight

* Retention-driven business
* Strong loyalty
* Discovery-based purchasing behavior

---

# 🎵 PHASE 6 — Product & Artist Insights

### Catalog Structure

| Metric                | Value |
| --------------------- | ----: |
| Avg Tracks per Album  |  6.19 |
| Avg Albums per Artist |  1.16 |

### Revenue by Genre (Balanced)

* Hip Hop, Classical, Blues, Country, Electronic lead
* No genre concentration risk

### Insight

* Broad artist coverage
* Long-tail catalog
* Low dependency on superstar artists

---

# 🚚 PHASE 7 — Vendor & Procurement

| Metric                | Value |
| --------------------- | ----: |
| Vendors               |   200 |
| Invoices              | 7,200 |
| Peak Procurement Year |  2024 |

### Insight

* Highly diversified supplier base
* No vendor dependency risk
* Procurement scales with demand

---

# 📈 PHASE 8 — Business Health Metrics

| KPI                 |   Value |
| ------------------- | ------: |
| Inventory Turnover  |  432.64 |
| 2024 Revenue Growth |  +7.61% |
| 2024 Order Growth   | +15.84% |

### Interpretation

* Extremely capital-efficient
* Digital inventory velocity model
* Scalable growth without inventory buildup

---

# 🏆 PHASE 9 — Executive Summary

### Headline KPIs

| KPI              |   Value |
| ---------------- | ------: |
| Total Revenue    |  $1.73M |
| Orders           |  62,500 |
| Items Sold       | 160,499 |
| Active Customers |  26,264 |
| Repeat Rate      |   70.7% |
| Vendors          |     200 |
| Stores           |      15 |

---

# 🧠 Business Classification (Final)

| Category       | Classification          |
| -------------- | ----------------------- |
| Industry       | Music Retail            |
| Model          | Omnichannel Commerce    |
| Customer Type  | B2C                     |
| Supply Chain   | Vendor-managed          |
| Scale          | Medium                  |
| Inventory Type | Digital / Fast-turnover |
| Risk Level     | Low–Moderate            |
| Growth Stage   | Expansion               |

---

# 🎓 Strategic Interpretation

This project models a **modern digital retail company**, not a distributor.

It demonstrates:

* Integrated data warehousing
* Multi-year analytics
* Executive-level KPIs
* End-to-end business simulation

> *This is a complete Music Retail Data Warehouse & Analytics System — not a student database exercise.*

**End of Document**
