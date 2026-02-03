-- ======================================================
-- INVENTORY TRIGGER VALIDATION QUERIES
-- ======================================================

-- 1. How many times stock was ADDED (trigger fires)
SELECT COUNT(*) AS stock_add_events
FROM invoice_items_details;

-- 2. How many times stock was REMOVED (trigger fires)
SELECT COUNT(*) AS stock_remove_events
FROM order_items;

-- 3. How many albums were restocked
SELECT COUNT(DISTINCT album_id) AS albums_restocked
FROM invoice_items_details;

-- 4. How many albums were sold
SELECT COUNT(DISTINCT album_id) AS albums_sold
FROM order_items;

-- 5. Total quantity added to stock
SELECT SUM(quantity_bought) AS total_units_added
FROM invoice_items_details;

-- 6. Total quantity sold
SELECT SUM(quantity_to_buy) AS total_units_sold
FROM order_items;

-- 7. Famous vs Non-Famous stock SOLD
SELECT
  CASE
    WHEN fa.artist_id IS NOT NULL THEN 'Famous'
    ELSE 'Non-Famous'
  END AS artist_type,
  SUM(oi.quantity_to_buy) AS total_units_sold
FROM order_items oi
JOIN album a ON oi.album_id = a.album_id
LEFT JOIN famous_artists fa ON a.artist_id = fa.artist_id
GROUP BY artist_type;

-- 8. Famous vs Non-Famous CURRENT STOCK
SELECT
  CASE
    WHEN fa.artist_id IS NOT NULL THEN 'Famous'
    ELSE 'Non-Famous'
  END AS artist_type,
  COUNT(DISTINCT a.album_id) AS albums,
  ROUND(AVG(a.album_copies_available), 2) AS avg_current_stock,
  MIN(a.album_copies_available) AS min_stock,
  MAX(a.album_copies_available) AS max_stock
FROM album a
LEFT JOIN famous_artists fa ON a.artist_id = fa.artist_id
GROUP BY artist_type;

-- 9. Net inventory movement per album (sanity check)
SELECT
  a.album_id,
  a.album_name,
  COALESCE(SUM(ii.quantity_bought), 0) AS total_added,
  COALESCE(SUM(oi.quantity_to_buy), 0) AS total_sold,
  a.album_copies_available AS current_stock
FROM album a
LEFT JOIN invoice_items_details ii ON a.album_id = ii.album_id
LEFT JOIN order_items oi ON a.album_id = oi.album_id
GROUP BY a.album_id, a.album_name, a.album_copies_available;
