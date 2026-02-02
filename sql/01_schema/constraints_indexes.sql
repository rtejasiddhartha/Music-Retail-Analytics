-- Index to speed up joins and filters on customer_id in orders
CREATE INDEX idx_orders_customer_id 
ON orders(customer_id);

-- Optional rollback: drop index if needed
-- ALTER TABLE orders DROP INDEX idx_orders_customer_id;


-- Index to optimize queries filtering or sorting by order_date
CREATE INDEX idx_orders_order_date 
ON orders(order_date);


-- Composite index to optimize customer spending and date-based reports
-- Useful when filtering by order_date and grouping by customer
CREATE INDEX idx_orders_orderdate_customer 
ON orders(order_date, customer_id, order_id);


-- Covering index to speed up joins between orders and order_items
-- Avoids extra table lookups for quantity and price
CREATE INDEX cidx_order_items_orderid_album_qty_price 
ON order_items(order_id, album_id, quantity_to_buy, unit_price);


-- Index to optimize date-based order lookups joined with order_items
CREATE INDEX idx_orders_orderdate_orderid 
ON orders(order_date, order_id);


-- Index to optimize album-level aggregation in order_items
CREATE INDEX idx_order_items_albumid_qty 
ON order_items(album_id, quantity_to_buy);


-- Index to optimize cost comparison logic in loss/profit analysis
CREATE INDEX idx_invoice_items_album_itemprice 
ON invoice_items_details(album_id, item_price);
