/*
File: row_counts.sql

Purpose:
Quick sanity check to verify row counts across all core tables
after schema creation and bulk data inserts.

Usage:
Run after full data load or after individual batch inserts
to ensure no silent failures or missing records.
*/

SELECT 'track' AS table_name, COUNT(*) AS row_count FROM track
UNION ALL
SELECT 'album', COUNT(*) FROM album
UNION ALL
SELECT 'artist', COUNT(*) FROM artist
UNION ALL
SELECT 'city', COUNT(*) FROM city
UNION ALL
SELECT 'country', COUNT(*) FROM country
UNION ALL
SELECT 'genre', COUNT(*) FROM genre
UNION ALL
SELECT 'customer', COUNT(*) FROM customer
UNION ALL
SELECT 'customer_address', COUNT(*) FROM customer_address
UNION ALL
SELECT 'invoice_items_details', COUNT(*) FROM invoice_items_details
UNION ALL
SELECT 'province', COUNT(*) FROM province
UNION ALL
SELECT 'invoices', COUNT(*) FROM invoices
UNION ALL
SELECT 'media_type', COUNT(*) FROM media_type
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_type', COUNT(*) FROM order_type
UNION ALL
SELECT 'vendor', COUNT(*) FROM vendor
UNION ALL
SELECT 'famous_artists', COUNT(*) FROM famous_artists
UNION ALL
SELECT 'store_location', COUNT(*) FROM store_location;
