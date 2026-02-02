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
