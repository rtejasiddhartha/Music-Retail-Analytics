/* =========================================================
   FILE: 04_time_series_analysis.sql

   PURPOSE:
   - Time-based analytics using dim_date
   - Demonstrates proper OLAP modeling
   - Avoids YEAR(), MONTH() directly on fact tables
   - Ensures correct DATE ↔ DATETIME grain alignment

   NOTE:
   orders.order_date is DATETIME
   dim_date.date_key is DATE
   → Always cast order_date to DATE while joining
   ========================================================= */


/* =========================================================
   1. Total Orders per Year
   Concept:
   - Basic time aggregation
   - Uses dim_date instead of YEAR(order_date)
   ========================================================= */

SELECT
    d.year,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN dim_date d
    ON DATE(o.order_date) = d.date_key
GROUP BY d.year
ORDER BY d.year;


/* =========================================================
   2. Total Revenue per Year
   Concept:
   - Fact table: order_items
   - Time dimension: dim_date
   - Measures yearly business growth
   ========================================================= */

SELECT
    d.year,
    ROUND(SUM(oi.unit_price * oi.quantity_to_buy), 2) AS total_revenue
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN dim_date d
    ON DATE(o.order_date) = d.date_key
GROUP BY d.year
ORDER BY d.year;


/* =========================================================
   3. Orders per Month (Year-Month Trend)
   Concept:
   - Uses yyyymm surrogate from dim_date
   - Enables easy trend charting
   ========================================================= */

SELECT
    d.year,
    d.month,
    d.yyyymm,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN dim_date d
    ON DATE(o.order_date) = d.date_key
GROUP BY d.year, d.month, d.yyyymm
ORDER BY d.yyyymm;


/* =========================================================
   4. Revenue per Month
   Concept:
   - Monthly revenue trend
   - Detects seasonality
   ========================================================= */

SELECT
    d.year,
    d.month,
    d.yyyymm,
    ROUND(SUM(oi.unit_price * oi.quantity_to_buy), 2) AS monthly_revenue
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN dim_date d
    ON DATE(o.order_date) = d.date_key
GROUP BY d.year, d.month, d.yyyymm
ORDER BY d.yyyymm;


/* =========================================================
   5. Orders by Weekday vs Weekend
   Concept:
   - Behavioral time analysis
   - Uses weekday flags from dim_date
   ========================================================= */

SELECT
    d.weekday_name,
    d.is_weekend,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN dim_date d
    ON DATE(o.order_date) = d.date_key
GROUP BY d.weekday_name, d.is_weekend
ORDER BY d.is_weekend, total_orders DESC;


/* =========================================================
   6. Average Orders per Day (Daily Intensity)
   Concept:
   - Measures daily system load
   - Useful for ops & capacity planning
   ========================================================= */

SELECT
    d.date_key,
    COUNT(o.order_id) AS orders_per_day
FROM orders o
JOIN dim_date d
    ON DATE(o.order_date) = d.date_key
GROUP BY d.date_key
ORDER BY d.date_key;


/* =========================================================
   7. Running Total of Orders Over Time
   Concept:
   - Window function + time dimension
   - Cumulative growth tracking
   ========================================================= */

SELECT
    d.date_key,
    COUNT(o.order_id) AS daily_orders,
    SUM(COUNT(o.order_id)) OVER (ORDER BY d.date_key) AS running_orders
FROM orders o
JOIN dim_date d
    ON DATE(o.order_date) = d.date_key
GROUP BY d.date_key
ORDER BY d.date_key;


/* =========================================================
   8. Year-over-Year Order Comparison
   Concept:
   - Uses self comparison via window function
   - Detects growth or decline
   ========================================================= */

WITH yearly_orders AS (
    SELECT
        d.year,
        COUNT(o.order_id) AS total_orders
    FROM orders o
    JOIN dim_date d
        ON DATE(o.order_date) = d.date_key
    GROUP BY d.year
)
SELECT
    year,
    total_orders,
    total_orders - LAG(total_orders) OVER (ORDER BY year) AS yoy_change
FROM yearly_orders
ORDER BY year;


/* =========================================================
   9. Peak Order Days
   Concept:
   - Identifies unusually high-volume days
   - Useful for anomaly detection
   ========================================================= */

SELECT
    d.date_key,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN dim_date d
    ON DATE(o.order_date) = d.date_key
GROUP BY d.date_key
HAVING COUNT(o.order_id) > (
    SELECT AVG(daily_orders)
    FROM (
        SELECT COUNT(order_id) AS daily_orders
        FROM orders
        GROUP BY DATE(order_date)
    ) x
)
ORDER BY total_orders DESC;
