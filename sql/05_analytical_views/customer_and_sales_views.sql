/*
File: customer_and_sales_views.sql

Purpose:
Analytical views for customer spending, sales performance,
geographic hierarchy, and loss analysis.
Designed for reporting and BI tools.
*/


-- =====================================================
-- VIEW 1: Customers and their total spend in March 2025
-- =====================================================

CREATE OR REPLACE VIEW Clients_Total_Spent AS
SELECT 
    c.customer_id,
    CONCAT(c.firstname, ' ', c.lastname) AS client_name,
    SUM(oi.unit_price * oi.quantity_to_buy) AS total_spent
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_date BETWEEN '2025-03-01' AND '2025-03-31 23:59:59'
GROUP BY c.customer_id;


-- Customers whose spend is above the March average
SELECT *
FROM Clients_Total_Spent
WHERE total_spent > (
    SELECT AVG(total_spent) FROM Clients_Total_Spent
);


-- =====================================================
-- VIEW 2: Top and least sold albums (Mar 7–13, 2025)
-- =====================================================

DROP VIEW IF EXISTS TOP_AND_LEAST_SOLD_ALBUMS;

CREATE VIEW TOP_AND_LEAST_SOLD_ALBUMS AS
SELECT 
    a.album_id,
    a.album_name,
    SUM(oi.quantity_to_buy) AS quantity_bought
FROM album a
JOIN order_items oi ON a.album_id = oi.album_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_date BETWEEN '2025-03-07' AND '2025-03-13 23:59:59'
GROUP BY a.album_id, a.album_name;


-- Highest and lowest selling albums in the period
SELECT album_name, quantity_bought
FROM TOP_AND_LEAST_SOLD_ALBUMS
WHERE quantity_bought = (SELECT MAX(quantity_bought) FROM TOP_AND_LEAST_SOLD_ALBUMS)
UNION
SELECT album_name, quantity_bought
FROM TOP_AND_LEAST_SOLD_ALBUMS
WHERE quantity_bought = (SELECT MIN(quantity_bought) FROM TOP_AND_LEAST_SOLD_ALBUMS);


-- =====================================================
-- VIEW 3: Hierarchical customer counts (City → Province → Country)
-- =====================================================

-- City-level customer counts
DROP VIEW IF EXISTS Customers_in_City_Count;
CREATE VIEW Customers_in_City_Count AS
SELECT 
    ci.city_id,
    ci.city_name,
    ci.province_id,
    COUNT(ca.customer_id) AS customer_count
FROM customer_address ca
JOIN city ci ON ca.city_id = ci.city_id
GROUP BY ci.city_id, ci.city_name, ci.province_id;


-- Province-level aggregation
DROP VIEW IF EXISTS Customers_in_Province_Count;
CREATE VIEW Customers_in_Province_Count AS
SELECT 
    p.province_id,
    p.province_name,
    p.country_id,
    SUM(c.customer_count) AS customer_count
FROM Customers_in_City_Count c
JOIN province p ON c.province_id = p.province_id
GROUP BY p.province_id, p.province_name, p.country_id;


-- Country-level aggregation
DROP VIEW IF EXISTS Customers_in_Country_Count;
CREATE VIEW Customers_in_Country_Count AS
SELECT 
    co.country_id,
    co.country_name,
    SUM(p.customer_count) AS customer_count
FROM Customers_in_Province_Count p
JOIN country co ON p.country_id = co.country_id
GROUP BY co.country_id, co.country_name;

-- Cummulative Customer Count
SELECT
    'City' AS level_type,
    c.city_id AS city_id,
    c.city_name AS city_name,
    c.province_id AS province_id,
    p.country_id AS country_id,
    c.customer_count
FROM Customers_in_City_Count c
JOIN province p
    ON c.province_id = p.province_id

UNION ALL

SELECT
    'Province' AS level_type,
    NULL AS city_id,
    NULL AS city_name,
    p.province_id AS province_id,
    p.country_id AS country_id,
    p.customer_count
FROM Customers_in_Province_Count p

UNION ALL

SELECT
    'Country' AS level_type,
    NULL AS city_id,
    NULL AS city_name,
    NULL AS province_id,
    co.country_id AS country_id,
    co.customer_count
FROM Customers_in_Country_Count co

ORDER BY
    country_id,
    province_id,
    city_id;


-- =====================================================
-- VIEW 4: Full customer profile with geography
-- =====================================================

DROP VIEW IF EXISTS vw_customer_full_profile;

CREATE VIEW vw_customer_full_profile AS
SELECT 
    c.customer_id,
    CONCAT_WS(' ', c.firstname, c.lastname) AS full_name,
    CONCAT_WS(' ', ca.line1, ca.line2) AS address_line,
    ci.city_name,
    p.province_name,
    co.country_name
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN city ci ON ca.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
JOIN country co ON p.country_id = co.country_id;


-- Example usage: Canadian customers
SELECT *
FROM vw_customer_full_profile
WHERE country_name = 'Canada';


-- =====================================================
-- VIEW 5: Loss-making order items (vendor price > selling price)
-- =====================================================

CREATE OR REPLACE VIEW vw_detailed_loss_orders AS
SELECT 
    oi.order_id,
    oi.album_id,
    a.album_name,
    oi.unit_price,
    oi.quantity_to_buy,
    vp.vendor_price,
    (oi.unit_price - vp.vendor_price) * oi.quantity_to_buy AS loss_amount
FROM order_items oi
JOIN album a ON oi.album_id = a.album_id
JOIN (
    SELECT album_id, MIN(item_price) AS vendor_price
    FROM invoice_items_details
    GROUP BY album_id
) vp ON oi.album_id = vp.album_id
WHERE oi.unit_price < vp.vendor_price;


-- Top 3 albums with highest total loss
SELECT 
    album_name,
    ROUND(SUM(loss_amount), 2) AS total_loss
FROM vw_detailed_loss_orders
GROUP BY album_name
ORDER BY total_loss ASC
LIMIT 3;


-- Year-wise loss trend for top 3 loss-making albums
WITH top_3_loss_albums AS (
    SELECT album_id
    FROM vw_detailed_loss_orders
    GROUP BY album_id
    ORDER BY SUM(loss_amount) ASC
    LIMIT 3
)
SELECT 
    YEAR(o.order_date) AS year,
    a.album_name,
    ROUND(SUM(v.loss_amount), 2) AS total_loss
FROM vw_detailed_loss_orders v
JOIN orders o ON v.order_id = o.order_id
JOIN album a ON v.album_id = a.album_id
WHERE v.album_id IN (SELECT album_id FROM top_3_loss_albums)
GROUP BY year, a.album_name
ORDER BY year, total_loss ASC;


-- Number of unique orders that include at least one loss item
SELECT COUNT(DISTINCT order_id) AS total_loss_orders
FROM vw_detailed_loss_orders;


-- Albums with total loss greater than 500
SELECT 
    album_name,
    ROUND(SUM(loss_amount), 2) AS total_loss
FROM vw_detailed_loss_orders
GROUP BY album_name
HAVING ABS(total_loss) > 500
ORDER BY total_loss ASC;
