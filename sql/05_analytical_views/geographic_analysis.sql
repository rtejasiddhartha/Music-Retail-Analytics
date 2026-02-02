/* =========================================================
   Geographic & Channel Analysis
   Purpose:
   - Analyze customer distribution by geography
   - Compare online vs store behavior
   - Evaluate store pickup patterns
   ========================================================= */

-- Customers count by country (normalized geography)
SELECT 
    co.country_name,
    COUNT(DISTINCT c.customer_id) AS customers
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN city ci ON ca.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
JOIN country co ON p.country_id = co.country_id
GROUP BY co.country_name
ORDER BY customers DESC;


-- Active customers (at least one order) by country
SELECT 
    co.country_name,
    COUNT(DISTINCT o.customer_id) AS active_customers
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN city ci ON ca.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
JOIN country co ON p.country_id = co.country_id
GROUP BY co.country_name
ORDER BY active_customers DESC;


-- Unique customers per album per country
SELECT 
    a.album_name,
    co.country_name,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN album a ON oi.album_id = a.album_id
JOIN customer c ON o.customer_id = c.customer_id
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN city ci ON ca.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
JOIN country co ON p.country_id = co.country_id
GROUP BY a.album_name, co.country_name
ORDER BY unique_customers DESC;


-- Store pickup orders by store city
SELECT 
    ci.city_name,
    COUNT(*) AS store_orders
FROM orders o
JOIN store_location sl ON o.store_id = sl.store_id
JOIN city ci ON sl.city_id = ci.city_id
WHERE o.order_type_id = 2
GROUP BY ci.city_name
ORDER BY store_orders DESC;


-- Online orders by customer country
SELECT 
    co.country_name,
    COUNT(*) AS online_orders
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN city ci ON ca.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
JOIN country co ON p.country_id = co.country_id
WHERE o.order_type_id = 1
GROUP BY co.country_name
ORDER BY online_orders DESC;


-- Compare customer city vs store city for store pickup orders
SELECT 
    CASE 
        WHEN cust_ci.city_name = store_ci.city_name THEN 'Same City'
        ELSE 'Different City'
    END AS purchase_city_type,
    COUNT(*) AS orders
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN city cust_ci ON ca.city_id = cust_ci.city_id
JOIN store_location sl ON o.store_id = sl.store_id
JOIN city store_ci ON sl.city_id = store_ci.city_id
WHERE o.order_type_id = 2
GROUP BY purchase_city_type;


-- Customers picking up orders from a store in a different city
SELECT 
    o.order_id,
    cust_ci.city_name AS customer_city,
    store_ci.city_name AS store_city
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN city cust_ci ON ca.city_id = cust_ci.city_id
JOIN store_location sl ON o.store_id = sl.store_id
JOIN city store_ci ON sl.city_id = store_ci.city_id
WHERE o.order_type_id = 2
  AND cust_ci.city_name <> store_ci.city_name
LIMIT 50;
