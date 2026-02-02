-- Inspect execution plan for customer order history query
EXPLAIN
SELECT order_id, order_date, store_id
FROM orders
WHERE customer_id = 12500
ORDER BY order_date DESC
LIMIT 20;


-- Inspect execution plan for aggregation-heavy customer order counts
EXPLAIN
SELECT customer_id,
       COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;
