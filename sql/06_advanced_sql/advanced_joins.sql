/* =========================================================
   FILE: advanced_joins.sql
   PURPOSE:
   - Demonstrate advanced JOIN patterns used in analytics
   - Show how JOIN choice affects business meaning
   - Cover semi-joins, anti-joins, self-joins, and pitfalls
   ========================================================= */


/* =========================================================
   SECTION 1: INNER vs LEFT JOIN (MEANING DIFFERENCE)
   ========================================================= */

-- 1. Customers who have placed at least one order
-- Concept:
--   - INNER JOIN removes customers with no orders
--   - Represents "active customers"

SELECT DISTINCT
    c.customer_id,
    c.firstname,
    c.lastname
FROM customer c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;


-- 2. All customers and their orders (including customers with no orders)
-- Concept:
--   - LEFT JOIN preserves all customers
--   - NULL order_id indicates no purchase history

SELECT
    c.customer_id,
    c.firstname,
    c.lastname,
    o.order_id
FROM customer c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id;


/* =========================================================
   SECTION 2: SEMI-JOINS (EXISTS)
   ========================================================= */

-- 3. Customers who have placed at least one order (EXISTS version)
-- Concept:
--   - Semi-join: returns rows from left table only
--   - Often clearer and safer than INNER JOIN + DISTINCT

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


-- 4. Albums that have been sold at least once
-- Concept:
--   - EXISTS stops searching after first match (efficient)

SELECT
    a.album_id,
    a.album_name
FROM album a
WHERE EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.album_id = a.album_id
);


/* =========================================================
   SECTION 3: ANTI-JOINS (NOT EXISTS)
   ========================================================= */

-- 5. Customers who have NEVER placed an order
-- Concept:
--   - Anti-join using NOT EXISTS
--   - Very common analytics requirement

SELECT
    c.customer_id,
    c.firstname,
    c.lastname
FROM customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);


-- 6. Albums that have NEVER been ordered
-- Concept:
--   - Identifies dead inventory or catalog gaps

SELECT
    a.album_id,
    a.album_name
FROM album a
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.album_id = a.album_id
);


/* =========================================================
   SECTION 4: LEFT JOIN + NULL CHECK (ANTI-JOIN ALTERNATIVE)
   ========================================================= */

-- 7. Albums never ordered (LEFT JOIN approach)
-- Concept:
--   - LEFT JOIN + NULL filter
--   - Functionally similar to NOT EXISTS

SELECT
    a.album_id,
    a.album_name
FROM album a
LEFT JOIN order_items oi
    ON a.album_id = oi.album_id
WHERE oi.album_id IS NULL;


/* =========================================================
   SECTION 5: SELF-JOINS
   ========================================================= */

-- 8. Customers sharing the same city
-- Concept:
--   - Self-join on customer_address
--   - Used for similarity / comparison problems

SELECT
    ca1.customer_id AS customer_1,
    ca2.customer_id AS customer_2,
    ca1.city_id
FROM customer_address ca1
JOIN customer_address ca2
    ON ca1.city_id = ca2.city_id
   AND ca1.customer_id < ca2.customer_id;


-- 9. Vendors operating in the same city
-- Concept:
--   - Self-join to detect geographic clustering

SELECT
    v1.vendor_id AS vendor_1,
    v2.vendor_id AS vendor_2,
    v1.city_id
FROM vendor v1
JOIN vendor v2
    ON v1.city_id = v2.city_id
   AND v1.vendor_id < v2.vendor_id;


/* =========================================================
   SECTION 6: JOINING MULTIPLE FACTS
   ========================================================= */

-- 10. Orders with both sales and procurement context
-- Concept:
--   - Combines customer orders and vendor cost data
--   - Shows cross-process analytics

SELECT
    o.order_id,
    o.customer_id,
    oi.album_id,
    oi.unit_price,
    ii.item_price AS vendor_price,
    (oi.unit_price - ii.item_price) AS margin_per_unit
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN invoice_items_details ii
    ON oi.album_id = ii.album_id;


/* =========================================================
   SECTION 7: JOIN PITFALLS & DATA DUPLICATION
   ========================================================= */

-- 11. Incorrect join that multiplies rows (demonstration)
-- Concept:
--   - Joining order_items to invoices without aggregation
--   - Can inflate revenue or cost numbers

SELECT
    oi.album_id,
    oi.order_id,
    ii.invoice_id
FROM order_items oi
JOIN invoice_items_details ii
    ON oi.album_id = ii.album_id;


-- 12. Corrected join using aggregation
-- Concept:
--   - Aggregate first, then join
--   - Prevents row explosion

WITH vendor_price AS (
    SELECT
        album_id,
        MIN(item_price) AS vendor_price
    FROM invoice_items_details
    GROUP BY album_id
)
SELECT
    oi.order_id,
    oi.album_id,
    oi.unit_price,
    vp.vendor_price
FROM order_items oi
JOIN vendor_price vp
    ON oi.album_id = vp.album_id;


/* =========================================================
   SECTION 8: BUSINESS-LEVEL JOIN QUESTION
   ========================================================= */

-- 13. Customers who ordered albums from famous artists
-- Concept:
--   - Multi-table join with business semantics

SELECT DISTINCT
    o.customer_id
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN album a
    ON oi.album_id = a.album_id
JOIN famous_artists fa
    ON a.artist_id = fa.artist_id;
