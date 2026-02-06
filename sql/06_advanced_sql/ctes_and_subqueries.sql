/* =========================================================
   PURPOSE:
   - Demonstrate Common Table Expressions (CTEs)
     and Subquery patterns for analytics
   - Show how complex analytical logic can be
     broken into readable, reusable steps
   - Focus on clarity, correctness, and intent
   ========================================================= */


/* =========================================================
   SECTION 1: BASIC SUBQUERIES (SCALAR & FILTERING)
   ========================================================= */

-- 1. Customers who placed more orders than the average customer
-- Concept:
--   - Inner subquery computes average orders per customer
--   - Outer query filters customers above that benchmark

SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) >
(
    SELECT AVG(order_count)
    FROM (
        SELECT customer_id, COUNT(order_id) AS order_count
        FROM orders
        GROUP BY customer_id
    ) avg_orders
);


-- 2. Albums priced above the overall average album price
-- Concept:
--   - Scalar subquery returning a single value

SELECT
    album_id,
    album_name,
    album_price
FROM album
WHERE album_price >
(
    SELECT AVG(album_price)
    FROM album
);


/* =========================================================
   SECTION 2: DERIVED TABLES (SUBQUERIES IN FROM)
   ========================================================= */

-- 3. Customers with total spending above average customer spend
-- Concept:
--   - Derived table computes total spend per customer
--   - Outer query compares against average spend

SELECT
    customer_id,
    total_spent
FROM (
    SELECT
        o.customer_id,
        SUM(oi.unit_price * oi.quantity_to_buy) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) customer_spend
WHERE total_spent >
(
    SELECT AVG(total_spent)
    FROM (
        SELECT
            o.customer_id,
            SUM(oi.unit_price * oi.quantity_to_buy) AS total_spent
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        GROUP BY o.customer_id
    ) avg_spend
);


/* =========================================================
   SECTION 3: BASIC CTEs (READABILITY & REUSE)
   ========================================================= */

-- 4. Total revenue per album using a CTE
-- Concept:
--   - CTE improves readability
--   - Same logic as derived table, but cleaner

WITH album_revenue AS (
    SELECT
        a.album_id,
        a.album_name,
        SUM(oi.unit_price * oi.quantity_to_buy) AS revenue
    FROM album a
    JOIN order_items oi ON a.album_id = oi.album_id
    GROUP BY a.album_id, a.album_name
)
SELECT *
FROM album_revenue
ORDER BY revenue DESC;


-- 5. Albums generating revenue above average album revenue
-- Concept:
--   - Reusing CTE results for benchmarking

WITH album_revenue AS (
    SELECT
        a.album_id,
        a.album_name,
        SUM(oi.unit_price * oi.quantity_to_buy) AS revenue
    FROM album a
    JOIN order_items oi ON a.album_id = oi.album_id
    GROUP BY a.album_id, a.album_name
)
SELECT
    album_id,
    album_name,
    revenue
FROM album_revenue
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM album_revenue
);


/* =========================================================
   SECTION 4: MULTI-STEP CTE PIPELINES
   ========================================================= */

-- 6. Yearly revenue and profit analysis
-- Concept:
--   - Step 1: compute revenue per year
--   - Step 2: compute vendor spend per year
--   - Step 3: combine for net profit

WITH yearly_revenue AS (
    SELECT
        YEAR(o.order_date) AS year,
        SUM(oi.unit_price * oi.quantity_to_buy) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY YEAR(o.order_date)
),
yearly_spend AS (
    SELECT
        YEAR(i.invoice_date) AS year,
        SUM(ii.item_price * ii.quantity_bought) AS spend
    FROM invoices i
    JOIN invoice_items_details ii ON i.invoice_id = ii.invoice_id
    GROUP BY YEAR(i.invoice_date)
)
SELECT
    r.year,
    r.revenue,
    s.spend,
    (r.revenue - s.spend) AS net_profit
FROM yearly_revenue r
JOIN yearly_spend s
  ON r.year = s.year
ORDER BY r.year;


/* =========================================================
   SECTION 5: CORRELATED SUBQUERIES
   ========================================================= */

-- 7. Orders whose value exceeds the customer's average order value
-- Concept:
--   - Subquery is evaluated per customer (correlated)

SELECT
    o.order_id,
    o.customer_id,
    SUM(oi.unit_price * oi.quantity_to_buy) AS order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.customer_id
HAVING SUM(oi.unit_price * oi.quantity_to_buy) >
(
    SELECT AVG(order_total)
    FROM (
        SELECT
            o2.order_id,
            SUM(oi2.unit_price * oi2.quantity_to_buy) AS order_total
        FROM orders o2
        JOIN order_items oi2 ON o2.order_id = oi2.order_id
        WHERE o2.customer_id = o.customer_id
        GROUP BY o2.order_id
    ) customer_orders
);


/* =========================================================
   SECTION 6: EXISTS / NOT EXISTS (SEMI & ANTI JOINS)
   ========================================================= */

-- 8. Albums that have never been ordered
-- Concept:
--   - Anti-join using NOT EXISTS

SELECT
    a.album_id,
    a.album_name
FROM album a
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.album_id = a.album_id
);


-- 9. Customers who have placed at least one order
-- Concept:
--   - Semi-join using EXISTS

SELECT
    c.customer_id,
    c.firstname,
    c.lastname
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);


/* =========================================================
   SECTION 7: ADVANCED ANALYTICAL CTE
   ========================================================= */

-- 10. Identify loss-making albums
-- Concept:
--   - Compare selling price vs vendor price
--   - Multi-level CTE for clarity

WITH vendor_cost AS (
    SELECT
        album_id,
        MIN(item_price) AS vendor_price
    FROM invoice_items_details
    GROUP BY album_id
),
album_sales AS (
    SELECT
        oi.album_id,
        SUM(oi.unit_price * oi.quantity_to_buy) AS sales_value
    FROM order_items oi
    GROUP BY oi.album_id
)
SELECT
    a.album_id,
    a.album_name,
    s.sales_value,
    v.vendor_price
FROM album a
JOIN album_sales s ON a.album_id = s.album_id
JOIN vendor_cost v ON a.album_id = v.album_id
WHERE s.sales_value < v.vendor_price;

