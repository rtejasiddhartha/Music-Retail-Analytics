-- ============================================================
-- Music Retail Data Warehouse & Analytics System
-- Phase 1 → Phase 9 Business Analytics Queries
-- Database: Music_Store_Analytics
--
-- This SQL file is the SINGLE SOURCE OF TRUTH for all metrics
-- used in the business case study and README documentation.
--
-- Recommended location:
--   /analytics/PHASE_1_TO_9_ANALYTICS_QUERIES.sql
--
-- All results referenced in the detailed business README
-- are derived directly from the queries below.
-- ============================================================

USE Music_Store_Analytics;

-- ============================================================
-- PHASE 1 — BUSINESS STRUCTURE (DATABASE SCALE)
-- ============================================================

-- Row count for all core tables to establish business scale
SELECT 'track' AS table_name, COUNT(*) AS row_count FROM track
UNION ALL
SELECT 'album', COUNT(*) FROM album
UNION ALL
SELECT 'artist', COUNT(*) FROM artist
UNION ALL
SELECT 'city', COUNT(*) FROM city
UNION ALL
SELECT 'country', COUNT(*) FROM country
UNION ALL
SELECT 'genre', COUNT(*) FROM genre
UNION ALL
SELECT 'customer', COUNT(*) FROM customer
UNION ALL
SELECT 'customer_address', COUNT(*) FROM customer_address
UNION ALL
SELECT 'invoice_items_details', COUNT(*) FROM invoice_items_details
UNION ALL
SELECT 'province', COUNT(*) FROM province
UNION ALL
SELECT 'invoices', COUNT(*) FROM invoices
UNION ALL
SELECT 'media_type', COUNT(*) FROM media_type
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_type', COUNT(*) FROM order_type
UNION ALL
SELECT 'vendor', COUNT(*) FROM vendor
UNION ALL
SELECT 'famous_artists', COUNT(*) FROM famous_artists
UNION ALL
SELECT 'store_location', COUNT(*) FROM store_location;

-- ============================================================
-- PHASE 2 — SALES PERFORMANCE
-- ============================================================

-- Total number of customer orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Total order line items (basket depth indicator)
SELECT COUNT(*) AS total_order_items
FROM order_items;

-- Total procurement invoices
SELECT COUNT(*) AS total_invoices
FROM invoices;

-- Total invoice line items (vendor-side granularity)
SELECT COUNT(*) AS total_invoice_items
FROM invoice_items_details;

-- Total business revenue
SELECT ROUND(SUM(quantity_to_buy * unit_price), 2) AS total_revenue
FROM order_items;

-- Revenue by year (used for YoY analysis)
SELECT 
    YEAR(o.order_date) AS year,
    ROUND(SUM(oi.quantity_to_buy * oi.unit_price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date)
ORDER BY year;

-- Orders by year (volume-driven growth analysis)
SELECT 
    YEAR(order_date) AS year,
    COUNT(*) AS orders_count
FROM orders
GROUP BY YEAR(order_date)
ORDER BY year;

-- Average Order Value (AOV)
SELECT 
ROUND(
    SUM(oi.quantity_to_buy * oi.unit_price) 
    / COUNT(DISTINCT o.order_id), 2
) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id;

-- Average number of items per order
SELECT ROUND(AVG(items_per_order), 2) AS avg_items_per_order
FROM (
    SELECT order_id, SUM(quantity_to_buy) AS items_per_order
    FROM order_items
    GROUP BY order_id
) t;

-- ============================================================
-- PHASE 3 — INVENTORY MOVEMENT
-- ============================================================

-- Total quantity sold (inventory outflow)
SELECT 
    SUM(quantity_to_buy) AS total_quantity_sold
FROM order_items;

-- Total stock received from vendors (inventory inflow)
SELECT 
    SUM(quantity_bought) AS total_stock_received
FROM invoice_items_details;

-- Net inventory movement (stock in - stock out)
SELECT 
    (SELECT SUM(quantity_bought) FROM invoice_items_details)
  - (SELECT SUM(quantity_to_buy) FROM order_items)
    AS net_inventory_movement;

-- Most sold album by unit volume
SELECT 
    a.album_name,
    SUM(oi.quantity_to_buy) AS units_sold
FROM order_items oi
JOIN album a ON oi.album_id = a.album_id
GROUP BY a.album_id, a.album_name
ORDER BY units_sold DESC
LIMIT 1;

-- Top 10 albums by revenue contribution
SELECT 
    a.album_name,
    ROUND(SUM(oi.quantity_to_buy * oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN album a ON oi.album_id = a.album_id
GROUP BY a.album_id, a.album_name
ORDER BY revenue DESC
LIMIT 10;

-- Bottom 10 albums by sales volume (slow-moving stock)
SELECT 
    a.album_name,
    SUM(oi.quantity_to_buy) AS units_sold
FROM order_items oi
JOIN album a ON oi.album_id = a.album_id
GROUP BY a.album_id, a.album_name
ORDER BY units_sold ASC
LIMIT 10;

-- ============================================================
-- PHASE 4 — STORE & CHANNEL ANALYSIS
-- ============================================================

-- Revenue by physical store (pickup only)
SELECT 
    sl.store_id,
    ROUND(SUM(oi.quantity_to_buy * oi.unit_price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN store_location sl ON o.store_id = sl.store_id
GROUP BY sl.store_id
ORDER BY revenue DESC;

-- Revenue by city (store pickup only)
SELECT 
    c.city_name,
    ROUND(SUM(oi.quantity_to_buy * oi.unit_price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN store_location sl ON o.store_id = sl.store_id
JOIN city c ON sl.city_id = c.city_id
GROUP BY c.city_name
ORDER BY revenue DESC;

-- Revenue by province (store pickup only)
SELECT 
    p.province_name,
    ROUND(SUM(oi.quantity_to_buy * oi.unit_price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN store_location sl ON o.store_id = sl.store_id
JOIN province p ON sl.province_id = p.province_id
GROUP BY p.province_name
ORDER BY revenue DESC;

-- Order count by channel (Online vs Pickup)
SELECT 
    ot.order_type_name,
    COUNT(*) AS orders_count
FROM orders o
JOIN order_type ot ON o.order_type_id = ot.order_type_id
GROUP BY ot.order_type_name;

-- Revenue by channel
SELECT 
    ot.order_type_name,
    ROUND(SUM(oi.quantity_to_buy * oi.unit_price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN order_type ot ON o.order_type_id = ot.order_type_id
GROUP BY ot.order_type_name;

-- Explicit online orders count
SELECT COUNT(*) AS online_orders
FROM orders
WHERE store_id IS NULL;

-- Explicit online revenue
SELECT 
    ROUND(SUM(oi.quantity_to_buy * oi.unit_price), 2) AS online_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.store_id IS NULL;

-- Explicit store pickup revenue
SELECT 
    ROUND(SUM(oi.quantity_to_buy * oi.unit_price), 2) AS store_pickup_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.store_id IS NOT NULL;

-- Channel revenue percentage contribution
SELECT
    order_type_name,
    ROUND(SUM(oi.quantity_to_buy * oi.unit_price), 2) AS revenue,
    ROUND(
        SUM(oi.quantity_to_buy * oi.unit_price) * 100 /
        (SELECT SUM(quantity_to_buy * unit_price) FROM order_items),
    2) AS revenue_percentage
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN order_type ot ON o.order_type_id = ot.order_type_id
GROUP BY order_type_name;

-- ============================================================
-- PHASE 5 — CUSTOMER ANALYTICS
-- ============================================================

-- Total active customers who placed at least one order
SELECT COUNT(DISTINCT customer_id) AS total_unique_customers
FROM orders;

-- Repeat customers (more than one order)
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) t;

-- Average number of orders per customer
SELECT 
    ROUND(
        COUNT(order_id) / COUNT(DISTINCT customer_id),
    2) AS avg_orders_per_customer
FROM orders;

-- Top 10 customers by lifetime spend
SELECT 
    c.customer_id,
    CONCAT(c.firstname, ' ', c.lastname) AS customer_name,
    ROUND(SUM(oi.quantity_to_buy * oi.unit_price), 2) AS total_spend
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customer c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spend DESC
LIMIT 10;

-- Average Customer Lifetime Value (CLV)
SELECT 
    ROUND(
        SUM(oi.quantity_to_buy * oi.unit_price)
        / COUNT(DISTINCT o.customer_id),
    2) AS avg_customer_lifetime_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id;

-- ============================================================
-- PHASE 6 — PRODUCT & ARTIST INSIGHTS
-- ============================================================

-- Revenue by genre
SELECT 
    g.genre_name,
    ROUND(SUM(oi.quantity_to_buy * oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN album a ON oi.album_id = a.album_id
JOIN genre g ON a.genre_id = g.genre_id
GROUP BY g.genre_name
ORDER BY revenue DESC;

-- Top 10 artists by revenue
SELECT 
    ar.artist_name,
    ROUND(SUM(oi.quantity_to_buy * oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN album a ON oi.album_id = a.album_id
JOIN artist ar ON a.artist_id = ar.artist_id
GROUP BY ar.artist_name
ORDER BY revenue DESC
LIMIT 10;

-- Average tracks per album
SELECT 
    ROUND(
        COUNT(track_id) / COUNT(DISTINCT album_id),
    2) AS avg_tracks_per_album
FROM track;

-- Average albums per artist
SELECT 
    ROUND(
        COUNT(album_id) / COUNT(DISTINCT artist_id),
    2) AS avg_albums_per_artist
FROM album;

-- ============================================================
-- PHASE 7 — VENDOR & PROCUREMENT
-- ============================================================

-- Total vendor transactions
SELECT COUNT(*) AS total_vendor_transactions
FROM invoices;

-- Procurement volume by year
SELECT 
    YEAR(i.invoice_date) AS year,
    SUM(ii.quantity_bought) AS total_quantity_purchased
FROM invoices i
JOIN invoice_items_details ii ON i.invoice_id = ii.invoice_id
GROUP BY YEAR(i.invoice_date)
ORDER BY year;

-- Top vendors by supply volume
SELECT 
    v.vendor_name,
    SUM(ii.quantity_bought) AS total_units_supplied
FROM invoices i
JOIN invoice_items_details ii ON i.invoice_id = ii.invoice_id
JOIN vendor v ON i.vendor_id = v.vendor_id
GROUP BY v.vendor_name
ORDER BY total_units_supplied DESC
LIMIT 10;

-- Vendor contribution to inventory value
SELECT 
    v.vendor_name,
    ROUND(SUM(ii.quantity_bought * ii.item_price), 2) AS inventory_value
FROM invoices i
JOIN invoice_items_details ii ON i.invoice_id = ii.invoice_id
JOIN vendor v ON i.vendor_id = v.vendor_id
GROUP BY v.vendor_name
ORDER BY inventory_value DESC;

-- ============================================================
-- PHASE 8 — BUSINESS HEALTH METRICS
-- ============================================================

-- Inventory turnover ratio (digital velocity indicator)
SELECT 
    ROUND(
        (SELECT SUM(quantity_to_buy) FROM order_items)
        /
        (SELECT AVG(album_copies_available) FROM album),
    2) AS inventory_turnover_ratio;

-- Year-over-year revenue growth (using LAG)
SELECT 
    year,
    revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year))
        / LAG(revenue) OVER (ORDER BY year) * 100,
    2) AS yoy_revenue_growth_pct
FROM (
    SELECT 
        YEAR(o.order_date) AS year,
        SUM(oi.quantity_to_buy * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY YEAR(o.order_date)
) t
ORDER BY year;

-- Year-over-year order growth
SELECT 
    year,
    orders_count,
    ROUND(
        (orders_count - LAG(orders_count) OVER (ORDER BY year))
        / LAG(orders_count) OVER (ORDER BY year) * 100,
    2) AS yoy_order_growth_pct
FROM (
    SELECT 
        YEAR(order_date) AS year,
        COUNT(*) AS orders_count
    FROM orders
    GROUP BY YEAR(order_date)
) t
ORDER BY year;

-- Active customers by year
SELECT 
    year,
    COUNT(DISTINCT customer_id) AS active_customers
FROM (
    SELECT 
        YEAR(order_date) AS year,
        customer_id
    FROM orders
) t
GROUP BY year
ORDER BY year;

-- ========================= END OF FILE =========================
