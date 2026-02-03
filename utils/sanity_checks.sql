/*
File: sanity_checks.sql
Purpose:
High-level business sanity checks.
Quick validations to ensure data behaves
reasonably before analytics & reporting.
*/

-- Orders exist per year
SELECT
    YEAR(order_date) AS year,
    COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_date);

-- Revenue vs vendor spend (overall)
SELECT
    ROUND(SUM(oi.unit_price * oi.quantity_to_buy), 2) AS total_revenue,
    ROUND(SUM(ii.item_price * ii.quantity_bought), 2) AS total_spend
FROM order_items oi
JOIN invoice_items_details ii ON oi.album_id = ii.album_id;

-- Negative inventory check
SELECT COUNT(*) AS negative_inventory
FROM album
WHERE album_copies_available < 0;

-- Order type distribution
SELECT
    ot.order_type_name,
    COUNT(*) AS total_orders
FROM orders o
JOIN order_type ot ON o.order_type_id = ot.order_type_id
GROUP BY ot.order_type_name;

-- Customers without orders (expected edge cases)
SELECT COUNT(*) AS customers_without_orders
FROM customer c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
