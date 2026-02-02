/*
File: data_simulation_updates.sql

Purpose:
Simulate realistic customer and address behavior in synthetic data:
1) Disable a subset of customer addresses
2) Align most customers' shipping address with billing address
3) Assign alternate shipping addresses for remaining customers

Notes:
- Designed for post-load execution
- Uses random sampling (RAND())
- Results will differ on each execution
*/

-- ------------------------------------------------------
-- 1) Disable ~6% of customer addresses
--    Simulates inactive or outdated addresses
-- ------------------------------------------------------

UPDATE customer_address AS ca
JOIN (
    SELECT address_id
    FROM customer_address
    ORDER BY RAND()
    LIMIT 1800   -- ~6% of ~30,000 addresses
) AS random_subset
ON ca.address_id = random_subset.address_id
SET ca.disabled = 1;


-- ------------------------------------------------------
-- 2) Set shipping address same as billing address
--    for ~80% of customers (common real-world pattern)
-- ------------------------------------------------------

UPDATE customer
SET shipping_address_id = billing_address_id
WHERE customer_id IN (
    SELECT customer_id
    FROM (
        SELECT customer_id
        FROM customer
        ORDER BY RAND()
        LIMIT 24000   -- ~80% of ~30,000 customers
    ) AS sub
);


-- ------------------------------------------------------
-- 3) Assign a different shipping address for remaining customers
--    Ensures shipping address is NOT the billing address
-- ------------------------------------------------------

UPDATE customer AS c
JOIN (
    SELECT 
        c.customer_id,
        a.address_id AS new_shipping_id
    FROM customer c
    JOIN customer_address a 
        ON a.customer_id = c.customer_id
    WHERE a.address_id <> c.billing_address_id
    ORDER BY RAND()
    LIMIT 6000   -- remaining ~20% of customers
) AS derived
ON c.customer_id = derived.customer_id
SET c.shipping_address_id = derived.new_shipping_id;
