/* =========================================================
   Profit & Revenue Contribution Analysis
   Purpose:
   - Evaluate revenue sources
   - Compare famous vs non-famous artist contribution
   ========================================================= */

-- Revenue contribution by non-famous artists
SELECT 
    art.artist_name,
    ROUND(SUM(oi.unit_price * oi.quantity_to_buy), 2) AS revenue
FROM order_items oi
JOIN album a ON oi.album_id = a.album_id
JOIN artist art ON a.artist_id = art.artist_id
LEFT JOIN famous_artists fa ON art.artist_id = fa.artist_id
WHERE fa.artist_id IS NULL
GROUP BY art.artist_name
ORDER BY revenue DESC
LIMIT 20;

-- Revenue contribution by artist type
SELECT 
    CASE 
        WHEN fa.artist_id IS NOT NULL THEN 'Famous'
        ELSE 'Non-Famous'
    END AS artist_type,
    ROUND(SUM(oi.unit_price * oi.quantity_to_buy), 2) AS total_revenue,
    COUNT(DISTINCT a.album_id) AS albums_sold
FROM order_items oi
JOIN album a ON oi.album_id = a.album_id
LEFT JOIN famous_artists fa ON a.artist_id = fa.artist_id
GROUP BY artist_type;

-- Profit contribution by artist type
SELECT 
    CASE 
        WHEN fa.artist_id IS NOT NULL THEN 'Famous'
        ELSE 'Non-Famous'
    END AS artist_type,
    ROUND(SUM((oi.unit_price - ii.item_price) * oi.quantity_to_buy), 2) AS total_profit
FROM order_items oi
JOIN invoice_items_details ii ON oi.album_id = ii.album_id
JOIN album a ON oi.album_id = a.album_id
LEFT JOIN famous_artists fa ON a.artist_id = fa.artist_id
WHERE oi.unit_price > ii.item_price
GROUP BY artist_type;

-- Loss contribution by artist type
SELECT 
    CASE 
        WHEN fa.artist_id IS NOT NULL THEN 'Famous'
        ELSE 'Non-Famous'
    END AS artist_type,
    ROUND(SUM((ii.item_price - oi.unit_price) * oi.quantity_to_buy), 2) AS total_loss
FROM order_items oi
JOIN invoice_items_details ii ON oi.album_id = ii.album_id
JOIN album a ON oi.album_id = a.album_id
LEFT JOIN famous_artists fa ON a.artist_id = fa.artist_id
WHERE oi.unit_price < ii.item_price
GROUP BY artist_type;

-- Average margin per album by artist type
SELECT 
    CASE 
        WHEN fa.artist_id IS NOT NULL THEN 'Famous'
        ELSE 'Non-Famous'
    END AS artist_type,
    ROUND(AVG(oi.unit_price - ii.item_price), 2) AS avg_margin
FROM order_items oi
JOIN invoice_items_details ii ON oi.album_id = ii.album_id
JOIN album a ON oi.album_id = a.album_id
LEFT JOIN famous_artists fa ON a.artist_id = fa.artist_id
GROUP BY artist_type;

-- Top 10 albums by total profit
SELECT 
    a.album_name,
    ROUND(SUM((oi.unit_price - ii.item_price) * oi.quantity_to_buy), 2) AS total_profit
FROM order_items oi
JOIN invoice_items_details ii ON oi.album_id = ii.album_id
JOIN album a ON oi.album_id = a.album_id
WHERE oi.unit_price > ii.item_price
GROUP BY a.album_name
ORDER BY total_profit DESC
LIMIT 10;

-- Famous artists: revenue vs profit
SELECT 
    ar.artist_name,
    ROUND(SUM(oi.unit_price * oi.quantity_to_buy), 2) AS revenue,
    ROUND(SUM((oi.unit_price - ii.item_price) * oi.quantity_to_buy), 2) AS profit
FROM order_items oi
JOIN invoice_items_details ii ON oi.album_id = ii.album_id
JOIN album a ON oi.album_id = a.album_id
JOIN artist ar ON a.artist_id = ar.artist_id
JOIN famous_artists fa ON ar.artist_id = fa.artist_id
GROUP BY ar.artist_name
ORDER BY revenue DESC
LIMIT 15;