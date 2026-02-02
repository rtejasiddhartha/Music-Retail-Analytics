/*
File: operational_metrics.sql
Purpose:
Operational KPIs describing customer activity,
order behavior, time trends, and system usage.
*/

-- =========================
-- CUSTOMER ACTIVITY
-- =========================

-- Orders per customer
SELECT 
    customer_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;

-- One-time customers
SELECT 
    c.customer_id,
    CONCAT(c.firstname, ' ', c.lastname) AS full_name
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING COUNT(*) = 1;

-- Average items per order
SELECT 
    ROUND(AVG(item_count), 2) AS avg_items_per_order
FROM (
    SELECT order_id, COUNT(*) AS item_count
    FROM order_items
    GROUP BY order_id
) t;

-- =========================
-- TIME-BASED PATTERNS
-- =========================

-- Orders per year
SELECT 
    YEAR(order_date) AS year,
    COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_date)
ORDER BY year;

-- Orders per hour of day
SELECT 
    HOUR(order_date) AS hour,
    COUNT(*) AS order_count
FROM orders
GROUP BY HOUR(order_date)
ORDER BY hour;

-- Orders by type
SELECT 
    ot.order_type_name,
    COUNT(*) AS total_orders
FROM orders o
JOIN order_type ot ON o.order_type_id = ot.order_type_id
GROUP BY ot.order_type_name;
