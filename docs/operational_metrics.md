# Operational Metrics Analysis

## Purpose
This analysis focuses on **operational KPIs** that describe how customers interact
with the system on a day-to-day basis.

It answers questions such as:
- How often customers place orders
- How complex typical orders are
- When orders are placed (time patterns)
- Which sales channels dominate usage

This layer bridges **OLTP activity** and **OLAP reporting**.

---

## Data Sources
Derived from the following transactional tables:

- `orders`
- `order_items`
- `customer`
- `order_type`

The metrics are computed using aggregation queries designed for
**business monitoring and reporting**, not transactional execution.

---

## 1. Customer Order Frequency

- Orders per customer range from **1 to 10**
- One-time customers: **7,688**

**Insights**
- A healthy mix of one-time and repeat customers
- Presence of repeat ordering (up to 10 orders) indicates realistic customer loyalty
- One-time customers form a significant segment, typical of retail discovery behavior

---

## 2. Average Items per Order

| Metric | Value |
|------|-------|
| Average items per order | **2.42** |

**Insights**
- Customers typically buy more than one item per order
- Basket size aligns with real-world music / media retail behavior
- Supports meaningful revenue and inventory analytics

---

## 3. Orders per Year

| Year | Total Orders |
|----|-------------|
| 2022 | 17,396 |
| 2023 | 17,524 |
| 2024 | 20,300 |
| 2025 | 7,280 |

**Insights**
- Gradual growth from 2022 to 2024
- 2025 shows partial-year behavior (lower volume expected)
- Pattern reflects a mature business with stable demand

---

## 4. Orders by Hour of Day

Orders are evenly distributed across all 24 hours, with hourly counts
typically ranging between **~2,500–2,700 orders per hour**.

**Insights**
- No artificial spikes or dead zones
- Represents global or multi-timezone ordering behavior
- Suitable for time-series dashboards and load analysis

---

## 5. Orders by Channel

| Order Type | Total Orders |
|----------|--------------|
| Online | 49,185 |
| Store Pickup | 13,315 |

**Insights**
- Online channel dominates (~79%)
- Store pickup remains a meaningful secondary channel
- Channel mix mirrors modern retail behavior

---

## Business Interpretation

Operational metrics confirm that:
- Customer behavior is diverse and realistic
- Order sizes and frequencies resemble real retail systems
- Channel usage is balanced and believable
- Time-based activity supports continuous operations

These KPIs are suitable for:
- Operational dashboards
- Capacity planning
- Customer behavior analysis

---

## OLTP vs OLAP Context

- **OLTP role**:
  - `orders`, `order_items` capture transactional events
- **OLAP role**:
  - Aggregations by customer, time, and channel
  - Trend analysis and performance monitoring

This analysis intentionally avoids write operations and focuses on
read-optimized reporting queries.

---



