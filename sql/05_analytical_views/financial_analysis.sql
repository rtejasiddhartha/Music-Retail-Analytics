/* =========================================================
   FILE: financial_analysis.sql
   PURPOSE:
   - Revenue, profit, and loss analysis
   - Vendor cost vs selling price comparisons
   - Financial health checks
   ========================================================= */

-- Total revenue per year
SELECT 
    YEAR(o.order_date) AS year, 
    ROUND(SUM(oi.unit_price * oi.quantity_to_buy), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date)
ORDER BY year;

-- Revenue split by order type
SELECT 
    YEAR(o.order_date) AS year,
    CASE 
        WHEN o.order_type_id = 1 THEN 'Online'
        WHEN o.order_type_id = 2 THEN 'Store Pickup'
    END AS order_type,
    ROUND(SUM(oi.unit_price * oi.quantity_to_buy), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date), o.order_type_id
ORDER BY year, order_type;

-- Top 10 albums by revenue
SELECT 
    a.album_id,
    a.album_name,
    ROUND(SUM(oi.unit_price * oi.quantity_to_buy), 2) AS revenue
FROM order_items oi
JOIN album a ON oi.album_id = a.album_id
GROUP BY a.album_id
ORDER BY revenue DESC
LIMIT 10;

-- =========================
-- COSTS / PROFIT / LOSS
-- =========================

-- Net profit per year
SELECT 
    YEAR(o.order_date) AS year,
    ROUND(SUM((oi.unit_price - ii.item_price) * oi.quantity_to_buy), 2) AS net_profit
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN invoice_items_details ii ON oi.album_id = ii.album_id
WHERE oi.unit_price > ii.item_price
GROUP BY YEAR(o.order_date)
ORDER BY year;

-- Albums sold at a loss
SELECT 
    a.album_name,
    ROUND(SUM((ii.item_price - oi.unit_price) * oi.quantity_to_buy), 2) AS total_loss
FROM order_items oi
JOIN invoice_items_details ii ON oi.album_id = ii.album_id
JOIN album a ON oi.album_id = a.album_id
WHERE oi.unit_price < ii.item_price
GROUP BY a.album_name
ORDER BY total_loss DESC;

-- Albums with negative average margin
SELECT 
    a.album_name,
    ROUND(AVG(oi.unit_price - ii.item_price), 2) AS avg_margin
FROM order_items oi
JOIN invoice_items_details ii ON oi.album_id = ii.album_id
JOIN album a ON oi.album_id = a.album_id
GROUP BY a.album_name
HAVING avg_margin < 0
ORDER BY avg_margin ASC;

-- =========================
-- INVENTORY & VENDORS
-- =========================

-- Total inventory value at selling price
SELECT 
    ROUND(SUM(album_price * album_copies_available), 2) AS total_inventory_value
FROM album;

-- Vendor spend per year
SELECT 
    YEAR(i.invoice_date) AS year,
    ROUND(SUM(ii.item_price * ii.quantity_bought), 2) AS total_spent
FROM invoices i
JOIN invoice_items_details ii ON i.invoice_id = ii.invoice_id
GROUP BY YEAR(i.invoice_date)
ORDER BY year;