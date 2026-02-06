/* =========================================================
   Running Order Count per Customer
   ---------------------------------------------------------
   Purpose:
   - Assign a cumulative (running) order count to each order
     for a customer based on chronological order.
   - Helps identify whether an order is a customer’s
     1st, 2nd, 3rd, ... purchase over time.
   ---------------------------------------------------------
   Logic:
   - PARTITION BY customer_id resets the count per customer
   - ORDER BY order_date ensures chronological sequencing
   - COUNT() OVER() produces a running total within each
     customer partition
   ========================================================= */

SELECT 
    order_id,
    customer_id,
    order_date,
    total_orders_by_customer
FROM (
    SELECT 
        order_id,
        customer_id,
        order_date,
        COUNT(order_id) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS total_orders_by_customer
    FROM orders
) x;

/* =========================================================
   Repeat Customer Orders
   ---------------------------------------------------------
   Purpose:
   - Identify orders placed by repeat customers
   - Excludes first-time purchases
   ---------------------------------------------------------
   Logic:
   - Compute a running order count per customer
   - Filter orders where the running count > 1
   ========================================================= */

SELECT 
    order_id,
    customer_id,
    order_date,
    total_orders_by_customer
FROM (
    SELECT 
        order_id,
        customer_id,
        order_date,
        COUNT(order_id) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS total_orders_by_customer
    FROM orders
) x
WHERE total_orders_by_customer > 1;

/* =========================================================
   Latest Order per Customer
   ---------------------------------------------------------
   Purpose:
   - Identify the most recent (latest) order placed
     by each customer.
   ---------------------------------------------------------
   Logic:
   - ROW_NUMBER() assigns a unique sequence to orders
     per customer, ordered from newest to oldest.
   - Filtering row_number = 1 returns exactly one
     latest order per customer.
   ========================================================= */

SELECT 
    order_id,
    customer_id,
    order_date
FROM (
    SELECT 
        order_id,
        customer_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS rn
    FROM orders
) x
WHERE rn = 1;

/* Total number of orders per customer using window functions
   ---------------------------------------------------------------
   - COUNT() OVER(PARTITION BY customer_id) calculates total orders
     for each customer and repeats the value on every row
   - ROW_NUMBER() is used only to collapse multiple rows per customer
     into a single representative row
   - Final WHERE rn = 1 ensures exactly one row per customer
*/
SELECT customer_id, total_orders_placed AS total_orders
FROM (
    SELECT
        customer_id,
        COUNT(order_id) OVER (PARTITION BY customer_id) AS total_orders_placed,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY customer_id) AS rn
    FROM orders
) x
WHERE x.rn = 1;

/* Album price vs genre average (multiple window functions)
   ---------------------------------------------------------------
   - AVG() OVER(PARTITION BY genre_id) gives genre-level benchmark
   - Album rows are preserved (no aggregation)
*/
SELECT
    album_id,
    album_name,
    genre_id,
    album_price,
    AVG(album_price) OVER (PARTITION BY genre_id) AS avg_genre_price,
    album_price - AVG(album_price) OVER (PARTITION BY genre_id) AS price_diff_from_genre_avg
FROM album;

/* Top-selling album per year */
SELECT year, album_id, album_name, total_sold
FROM (
    SELECT
        YEAR(o.order_date) AS year,
        a.album_id,
        a.album_name,
        SUM(oi.quantity_to_buy) AS total_sold,
        ROW_NUMBER() OVER (
            PARTITION BY YEAR(o.order_date)
            ORDER BY SUM(oi.quantity_to_buy) DESC
        ) AS rn
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN album a ON oi.album_id = a.album_id
    GROUP BY YEAR(o.order_date), a.album_id, a.album_name
) x
WHERE rn = 1;

/* Deduplicate customers by email, keeping latest customer_id */
SELECT customer_id, email
FROM (
    SELECT
        customer_id,
        email,
        ROW_NUMBER() OVER (
            PARTITION BY email
            ORDER BY customer_id DESC
        ) AS rn
    FROM customer
) x
WHERE rn = 1;

/* Days between consecutive orders */
SELECT
    order_id,
    customer_id,
    order_date,
    DATEDIFF(
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        )
    ) AS days_since_last_order
FROM orders
ORDER BY customer_id, order_date;

/* Price change compared to previous sale of same album */
SELECT
    oi.order_id,
    oi.album_id,
    oi.unit_price,
    LAG(oi.unit_price) OVER (
        PARTITION BY oi.album_id
        ORDER BY o.order_date
    ) AS previous_price,
    oi.unit_price - LAG(oi.unit_price) OVER (
        PARTITION BY oi.album_id
        ORDER BY o.order_date
    ) AS price_change
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id;

/* Customer segmentation by order volume (quartiles) */
SELECT
    customer_id,
    total_orders,
    NTILE(4) OVER (ORDER BY total_orders DESC) AS customer_quartile
FROM (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
) x;

/* Revenue percentile per album */
SELECT
    album_id,
    album_name,
    revenue,
    PERCENT_RANK() OVER (ORDER BY revenue) AS revenue_percentile
FROM (
    SELECT
        a.album_id,
        a.album_name,
        SUM(oi.unit_price * oi.quantity_to_buy) AS revenue
    FROM album a
    JOIN order_items oi ON a.album_id = oi.album_id
    GROUP BY a.album_id, a.album_name
) x;

/* 3-order moving average revenue per customer */
SELECT
    o.customer_id,
    o.order_date,
    SUM(oi.unit_price * oi.quantity_to_buy) AS order_revenue,
    AVG(SUM(oi.unit_price * oi.quantity_to_buy)) OVER (
        PARTITION BY o.customer_id
        ORDER BY o.order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id, o.order_date;

/* First-time orders where spend exceeds customer's average */
SELECT
    order_id,
    customer_id,
    order_revenue
FROM (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.unit_price * oi.quantity_to_buy) AS order_revenue,
        AVG(SUM(oi.unit_price * oi.quantity_to_buy)) OVER (
            PARTITION BY o.customer_id
        ) AS avg_customer_order_value,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date
        ) AS rn
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.customer_id, o.order_date
) x
WHERE rn = 1
  AND order_revenue > avg_customer_order_value;