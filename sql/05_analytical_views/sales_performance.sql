/* =========================================================
   Sales Performance Analysis
   Purpose:
   - Analyze album-level sales performance
   - Identify customer reach and demand intensity
   ========================================================= */

-- Number of unique customers who purchased each album
SELECT 
    a.album_id,
    a.album_name,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN album a ON oi.album_id = a.album_id
GROUP BY a.album_id, a.album_name
ORDER BY unique_customers DESC;


-- Albums with highest sales volume (order frequency)
SELECT 
    a.album_id,
    a.album_name,
    COUNT(*) AS total_orders
FROM order_items oi
JOIN album a ON oi.album_id = a.album_id
GROUP BY a.album_id, a.album_name
ORDER BY total_orders DESC
LIMIT 20;
