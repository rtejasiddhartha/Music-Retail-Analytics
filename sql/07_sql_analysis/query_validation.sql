-- Validate customer master data load
SELECT * FROM customer;


-- Retrieve recent orders for a specific customer
SELECT order_id,
       order_type_id,
       order_date,
       customer_id
FROM orders
WHERE customer_id = 12500
ORDER BY order_date DESC;


-- Count total orders per customer (distribution check)
SELECT customer_id,
       COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 20;


-- Identify non-online orders
SELECT o.order_id,
       o.order_type_id,
       ot.order_type_name,
       o.store_id
FROM orders o
JOIN order_type ot
  ON o.order_type_id = ot.order_type_id
WHERE ot.order_type_name <> 'Online'
ORDER BY o.order_id ASC;


-- Inspect store mappings
SELECT * FROM store_location;


-- Inspect order distribution by store
SELECT *
FROM orders
ORDER BY store_id ASC;

/* ------------------------------
   STRING FUNCTIONS & FORMATTING
   ------------------------------ */

-- Display customer names in a custom mixed-case format
SELECT 
  CONCAT(
    LOWER(SUBSTR(firstname, 1, 1)),
    UPPER(SUBSTR(firstname, 2)),
    ' ',
    LOWER(SUBSTR(lastname, 1, 1)),
    UPPER(SUBSTR(lastname, 2))
  ) AS modified_name_format
FROM customer;


/* ------------------------------
   FILTERING & CONDITIONAL LOGIC
   ------------------------------ */

-- Retrieve customers using complex ID conditions
SELECT *
FROM customer
WHERE ((customer_id > 3 AND customer_id < 8)
        OR customer_id = 10)
LIMIT 10;


-- View all orders (sanity check)
SELECT *
FROM orders;


-- Orders placed online within a specific date range
SELECT *
FROM orders
WHERE order_type_id = 1
  AND order_date BETWEEN DATE('2023-01-01') AND DATE('2023-12-12')
ORDER BY DATE(order_date) ASC, order_id ASC;


-- Customers matching specific first or last names (case-insensitive)
SELECT *
FROM customer
WHERE LOWER(firstname) IN ('jerry','jeremy','jeremiah')
   OR LOWER(lastname)  IN ('jerry','jeremy','jeremiah')
ORDER BY customer_id ASC;


/* ------------------------------
   CASE EXPRESSIONS
   ------------------------------ */

-- View vendor data
SELECT *
FROM vendor;


-- Categorize vendors based on city_id ranges
SELECT 
  vendor_id,
  vendor_name,
  city_id,
  CASE
    WHEN city_id BETWEEN 1 AND 100 THEN 'First 100 Cities'
    WHEN city_id BETWEEN 101 AND 200 THEN '101 to 200 Cities'
    ELSE 'Above 200'
  END AS city_group
FROM vendor
ORDER BY city_id ASC;


-- Categorize order item value into price buckets
SELECT 
  order_items_id,
  order_id,
  (unit_price * quantity_to_buy) AS total_price,
  CASE
    WHEN (unit_price * quantity_to_buy) < 5.00 THEN 'Under $5'
    WHEN (unit_price * quantity_to_buy) BETWEEN 5.00 AND 9.99 THEN '$5–$9.99'
    WHEN (unit_price * quantity_to_buy) BETWEEN 10.00 AND 19.99 THEN '$10–$19.99'
    ELSE 'Above $20'
  END AS price_bucket
FROM order_items
ORDER BY total_price ASC;


-- Inspect order_items sequencing
SELECT *
FROM order_items
ORDER BY order_items_id ASC;


/* ------------------------------
   JOIN PRACTICE & RELATIONSHIPS
   ------------------------------ */

-- Show all orders with matching order items (INNER JOIN)
SELECT 
  o.order_id,
  o.order_date,
  oi.order_items_id,
  oi.quantity_to_buy
FROM orders o
INNER JOIN order_items oi
  ON o.order_id = oi.order_id
ORDER BY o.order_id ASC;


-- Show all customers and their orders (NULL if no orders)
SELECT 
  c.customer_id,
  c.firstname,
  o.order_id
FROM customer c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
ORDER BY c.customer_id ASC;


-- Show all albums and their sales (NULL if album has no sales)
SELECT 
  a.album_id,
  a.album_name,
  oi.order_items_id
FROM order_items oi
RIGHT JOIN album a
  ON oi.album_id = a.album_id
ORDER BY a.album_id ASC;