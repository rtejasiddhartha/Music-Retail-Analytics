/*
File: data_quality_validation.sql

Purpose:
Post-load data validation & integrity checks.
Used to verify customer, vendor, album, artist, and invoice data
after all inserts are completed.

This file contains ONLY read-only validation queries
(no schema changes, no business logic).
*/

-- =========================================================
-- CUSTOMER GEOGRAPHY & ADDRESS VALIDATION
-- =========================================================

-- Customer count by country
SELECT 
    co.country_name,
    COUNT(*) AS customer_count
FROM customer_address ca
JOIN city ci ON ca.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
JOIN country co ON p.country_id = co.country_id
GROUP BY co.country_name;

-- Invalid Canadian postal codes (expected: A1A 1A1)
SELECT COUNT(*) AS invalid_canadian_postal_codes
FROM customer_address ca
JOIN city ci ON ca.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
WHERE p.country_id = 1
  AND ca.postal_code NOT REGEXP '^[A-Z][0-9][A-Z] [0-9][A-Z][0-9]$';

-- Invalid US ZIP codes (expected: 5 digits)
SELECT COUNT(*) AS invalid_us_postal_codes
FROM customer_address ca
JOIN city ci ON ca.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
WHERE p.country_id = 2
  AND ca.postal_code NOT REGEXP '^[0-9]{5}$';

-- Customer distribution by province/state
SELECT 
    p.province_name,
    co.country_name,
    COUNT(*) AS customer_count
FROM customer_address ca
JOIN city ci ON ca.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
JOIN country co ON p.country_id = co.country_id
GROUP BY p.province_name, co.country_name
ORDER BY customer_count DESC;

-- Top cities by customer count
SELECT 
    ci.city_name,
    p.province_name,
    co.country_name,
    COUNT(*) AS customer_count
FROM customer_address ca
JOIN city ci ON ca.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
JOIN country co ON p.country_id = co.country_id
GROUP BY ci.city_name, p.province_name, co.country_name
ORDER BY customer_count DESC;

-- Provinces/states with lowest customer count
SELECT 
    p.province_name,
    co.country_name,
    COUNT(*) AS customer_count
FROM customer_address ca
JOIN city ci ON ca.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
JOIN country co ON p.country_id = co.country_id
GROUP BY p.province_name, co.country_name
ORDER BY customer_count ASC
LIMIT 10;

-- Customers sharing same postal code
SELECT 
    postal_code,
    COUNT(*) AS customer_count
FROM customer_address
GROUP BY postal_code
ORDER BY customer_count DESC
LIMIT 20;

-- Address line2 (apartment/suite) usage
SELECT 
    COUNT(*) AS total_addresses,
    SUM(line2 IS NOT NULL) AS addresses_with_unit,
    ROUND(100 * SUM(line2 IS NOT NULL) / COUNT(*), 2) AS pct_with_unit
FROM customer_address;

-- Customers with more than one address (should be zero)
SELECT 
    customer_id,
    COUNT(*) AS address_count
FROM customer_address
GROUP BY customer_id
HAVING COUNT(*) <> 1;

-- Orphan customer addresses
SELECT COUNT(*) AS orphan_addresses
FROM customer_address ca
LEFT JOIN customer c ON ca.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- =========================================================
-- CUSTOMER PROFILE VALIDATION
-- =========================================================

-- Total customers loaded
SELECT COUNT(*) AS total_customers
FROM customer;

-- Billing vs shipping address comparison
SELECT
    SUM(billing_address_id = shipping_address_id) AS same_address,
    SUM(billing_address_id <> shipping_address_id) AS different_address,
    ROUND(
        100 * SUM(billing_address_id = shipping_address_id) / COUNT(*),
        2
    ) AS pct_same_address
FROM customer;

-- Invalid billing/shipping address references
SELECT COUNT(*) AS invalid_address_references
FROM customer c
LEFT JOIN customer_address b ON c.billing_address_id = b.address_id
LEFT JOIN customer_address s ON c.shipping_address_id = s.address_id
WHERE b.address_id IS NULL
   OR s.address_id IS NULL;

-- Duplicate emails
SELECT email, COUNT(*) AS cnt
FROM customer
GROUP BY email
HAVING COUNT(*) > 1;

-- Duplicate phone numbers
SELECT phone, COUNT(*) AS cnt
FROM customer
GROUP BY phone
HAVING COUNT(*) > 1;

-- Invalid email formats
SELECT COUNT(*) AS invalid_emails
FROM customer
WHERE email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$';

-- Same first & last name (edge case)
SELECT COUNT(*) AS same_first_last_name
FROM customer
WHERE firstname = lastname;

-- Age distribution
SELECT
    MIN(age) AS min_age,
    MAX(age) AS max_age,
    ROUND(AVG(age), 2) AS avg_age
FROM customer;

-- Suspicious age values
SELECT COUNT(*) AS suspicious_age_records
FROM customer
WHERE age < 13 OR age > 90;

-- =========================================================
-- VENDOR DATA QUALITY CHECKS
-- =========================================================

-- Total vendors
SELECT COUNT(*) AS total_vendors
FROM vendor;

-- Active vs inactive vendors
SELECT active, COUNT(*) AS vendor_count
FROM vendor
GROUP BY active;

-- Duplicate vendor names
SELECT vendor_name, COUNT(*) AS cnt
FROM vendor
GROUP BY vendor_name
HAVING COUNT(*) > 1;

-- Duplicate vendor phone numbers
SELECT phone, COUNT(*) AS cnt
FROM vendor
GROUP BY phone
HAVING COUNT(*) > 1;

-- Vendors sharing same address
SELECT address_line1, city_id, COUNT(*) AS cnt
FROM vendor
GROUP BY address_line1, city_id
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

-- Vendor distribution by country
SELECT
    co.country_name,
    COUNT(*) AS vendor_count
FROM vendor v
JOIN city ci ON v.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
JOIN country co ON p.country_id = co.country_id
GROUP BY co.country_name;

-- Invalid Canadian vendor postal codes
SELECT COUNT(*) AS invalid_canadian_vendor_postal
FROM vendor v
JOIN city ci ON v.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
WHERE p.country_id = 1
  AND v.postal_code NOT REGEXP '^[A-Z][0-9][A-Z] [0-9][A-Z][0-9]$';

-- Invalid US vendor ZIP codes
SELECT COUNT(*) AS invalid_us_vendor_zip
FROM vendor v
JOIN city ci ON v.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
WHERE p.country_id = 2
  AND v.postal_code NOT REGEXP '^[0-9]{5}$';

-- =========================================================
-- ARTIST / ALBUM CONSISTENCY CHECKS
-- =========================================================

-- Famous artists missing in artist master
SELECT fa.artist_id, fa.artist_name
FROM famous_artists fa
LEFT JOIN artist a ON fa.artist_id = a.artist_id
WHERE a.artist_id IS NULL;

-- Expected vs actual album count for famous artists
SELECT
    fa.artist_name,
    fa.num_albums AS expected_albums,
    COUNT(a.album_id) AS actual_albums,
    (fa.num_albums - COUNT(a.album_id)) AS missing_albums
FROM famous_artists fa
LEFT JOIN album a ON fa.artist_id = a.artist_id
GROUP BY fa.artist_name, fa.num_albums
ORDER BY missing_albums DESC;

-- Duplicate album names under same artist
SELECT
    artist_id,
    album_name,
    COUNT(*) AS cnt
FROM album
GROUP BY artist_id, album_name
HAVING COUNT(*) > 1;

-- Album price distribution (famous vs non-famous)
SELECT
    CASE
        WHEN fa.artist_id IS NOT NULL THEN 'Famous'
        ELSE 'Non-Famous'
    END AS artist_type,
    MIN(a.album_price) AS min_price,
    MAX(a.album_price) AS max_price,
    ROUND(AVG(a.album_price), 2) AS avg_price
FROM album a
LEFT JOIN famous_artists fa ON a.artist_id = fa.artist_id
GROUP BY artist_type;

-- Albums with unrealistic inventory levels
SELECT
    album_id,
    album_name,
    album_copies_available
FROM album
WHERE album_copies_available = 0
   OR album_copies_available > 1000
ORDER BY album_copies_available DESC;
