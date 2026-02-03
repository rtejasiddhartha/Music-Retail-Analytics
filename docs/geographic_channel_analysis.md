# Geographic & Channel Analysis

## Purpose
This analysis evaluates **customer distribution, sales channels, and store pickup behavior**
across geographies.  
It is designed to answer **where customers are**, **how they buy**, and **how physical stores
interact with online demand**.

The analysis supports **OLAP-style reporting** and downstream BI dashboards.

---

## Data Sources
The results in this document are derived from:

- `customer`, `customer_address`
- `orders`, `order_items`
- `city`, `province`, `country`
- `store_location`


---

## 1. Customer Distribution by Country

| Country | Total Customers |
|-------|----------------|
| Canada | 15,049 |
| United States | 14,951 |

**Insights**
- Near-equal customer base across Canada and the US
- Synthetic data is intentionally balanced to enable fair geographic comparisons
- Suitable for comparative market and growth analysis

---

## 2. Active Customers by Country

| Country | Active Customers |
|-------|------------------|
| Canada | 13,176 |
| United States | 13,088 |

**Insights**
- ~87% customer activation rate in both countries
- Indicates a mature, stable customer base
- Realistic for a long-running retail business rather than a toy dataset

---

## 3. Store Pickup Orders by Store City (Sample)

Top cities by store pickup volume include:

- Brossard (1,043)
- Brandon (1,011)
- Toronto (996)
- Brampton (980)
- Granby (968)

**Insights**
- Orders are distributed across many cities
- No single-city dominance → healthy store network
- Reflects real-world multi-store retail operations

---

## 4. Online Orders by Customer Country

| Country | Online Orders |
|-------|---------------|
| Canada | 24,837 |
| United States | 24,348 |

**Insights**
- Online demand is strong and evenly split across both countries
- Online order volume closely mirrors customer distribution
- No artificial channel bias in the dataset

---

## Business Interpretation

This analysis demonstrates:

- **Geographic normalization** (country → province → city)
- **Channel comparison** (online vs store pickup)
- **Physical–digital interaction** via store pickup behavior

The dataset reflects:
- Realistic customer engagement rates
- Balanced geographic demand
- Natural variance at the city level

---

## OLTP vs OLAP Context

- **OLTP tables**: `orders`, `order_items`, `customer`, `store_location`
- **OLAP usage**:
  - Aggregations by geography
  - Channel performance comparison
  - Customer activity analysis

These queries are intended for:
- Reporting
- Dashboards
- Business decision support  
—not transactional workflows.

---

## Why This Synthetic Data Is High Quality

- Preserves **real-world ratios** (activation, channel usage)
- Avoids extreme skews or artificial dominance
- Supports advanced analytics without manual cleanup

---
