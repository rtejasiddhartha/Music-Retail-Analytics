/* =========================================================
   FILE: ad_hoc_analysis.sql
   PURPOSE:
   - Exploratory business analysis
   - Artist, album, customer, and order insights
   - Used for manual analysis and reporting
   ========================================================= */

-- Displays all tracks by famous artists with album and media type
SELECT 
    fa.icon_id,
    fa.artist_id,
    fa.num_albums,
    ar.artist_name,
    al.album_id,
    t.track_id,
    al.album_name,
    t.track_name,
    t.media_type_id,
    t.track_length
FROM famous_artists fa
JOIN artist ar ON fa.artist_id = ar.artist_id
JOIN album al ON al.artist_id = ar.artist_id
JOIN track t ON t.album_id = al.album_id
ORDER BY fa.icon_id, al.album_id, t.track_id;

-- Display all tracks and albums for a given artist
SELECT 
    t.track_id,
    t.track_name,
    a.album_name
FROM track t
JOIN album a ON t.album_id = a.album_id
JOIN artist ar ON a.artist_id = ar.artist_id
WHERE ar.artist_name = 'Zayn';

-- Number of distinct albums per artist
SELECT 
    ar.artist_name,
    COUNT(DISTINCT a.album_name) AS album_count
FROM artist ar
JOIN album a ON ar.artist_id = a.artist_id
GROUP BY ar.artist_name
ORDER BY album_count DESC;

-- Total number of tracks per artist + overall total
SELECT 
    ar.artist_name,
    COUNT(tr.track_id) AS total_tracks
FROM artist ar
JOIN album ab ON ar.artist_id = ab.artist_id
JOIN track tr ON tr.album_id = ab.album_id
GROUP BY ar.artist_name

UNION ALL

SELECT 
    'TOTAL',
    COUNT(track_id)
FROM track;

-- Total length of each album (HH:MM:SS)
SELECT 
    a.album_name,
    FLOOR(album_length / 3600) AS hours,
    FLOOR((album_length % 3600) / 60) AS minutes,
    album_length % 60 AS seconds
FROM (
    SELECT album_id, SUM(track_length) AS album_length
    FROM track
    GROUP BY album_id
) t
JOIN album a ON a.album_id = t.album_id;

-- Albums by famous artists
SELECT 
    ar.artist_name,
    al.album_id,
    al.album_name
FROM album al
JOIN artist ar ON al.artist_id = ar.artist_id
JOIN famous_artists fa ON fa.artist_id = ar.artist_id
ORDER BY ar.artist_name, al.album_id;

-- Albums never ordered
SELECT 
    a.album_id,
    a.album_name
FROM album a
LEFT JOIN order_items oi ON a.album_id = oi.album_id
WHERE oi.album_id IS NULL;

-- =========================
-- CUSTOMERS & GEOGRAPHY
-- =========================

-- Customer full name with city, province, and country
SELECT 
    c.customer_id,
    CONCAT(c.firstname, ' ', c.lastname) AS full_name,
    ci.city_name,
    p.province_name,
    co.country_name
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN city ci ON ca.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
JOIN country co ON p.country_id = co.country_id
ORDER BY c.customer_id;

-- Customers by country
SELECT 
    co.country_name,
    COUNT(*) AS total_customers
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN city ci ON ca.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
JOIN country co ON p.country_id = co.country_id
GROUP BY co.country_name
ORDER BY total_customers DESC;

-- Orders by customer city
SELECT 
    ci.city_name,
    COUNT(*) AS orders
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN city ci ON ca.city_id = ci.city_id
GROUP BY ci.city_name
ORDER BY orders DESC;

-- Active vs disabled customer addresses
SELECT 
    disabled,
    COUNT(*) AS address_count
FROM customer_address
GROUP BY disabled;

-- Customers with same vs different billing/shipping addresses
SELECT 
    SUM(shipping_address_id = billing_address_id) AS same_address,
    SUM(shipping_address_id <> billing_address_id) AS different_address
FROM customer;

-- Disabled addresses by city
SELECT 
    ci.city_name,
    COUNT(*) AS disabled_count
FROM customer_address ca
JOIN city ci ON ca.city_id = ci.city_id
WHERE ca.disabled = 1
GROUP BY ci.city_name
ORDER BY disabled_count DESC;

-- =========================
-- VENDORS
-- =========================

-- Vendors by country (US & Canada)
SELECT 
    co.country_name,
    COUNT(*) AS total_vendors
FROM vendor v
JOIN city ci ON v.city_id = ci.city_id
JOIN province p ON ci.province_id = p.province_id
JOIN country co ON p.country_id = co.country_id
GROUP BY co.country_name;

-- Vendors with no invoices
SELECT 
    v.vendor_id,
    v.vendor_name
FROM vendor v
LEFT JOIN invoices i ON v.vendor_id = i.vendor_id
WHERE i.invoice_id IS NULL;