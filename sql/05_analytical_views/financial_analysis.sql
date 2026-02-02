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
