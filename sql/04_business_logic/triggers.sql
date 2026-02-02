/*
File: triggers.sql

Purpose:
- Maintain album inventory automatically
- Reduce stock when a customer places an order
- Increase stock when vendor inventory is received

*/

-- ======================================================
-- TRIGGER 1: Remove stock when a new order item is added
-- ======================================================

-- This trigger fires AFTER inserting a row into order_items
-- It reduces album stock based on quantity purchased by customer

DROP TRIGGER IF EXISTS Stock_Remove;
DELIMITER //

CREATE TRIGGER Stock_Remove
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE album
    SET album_copies_available = album_copies_available - NEW.quantity_to_buy
    WHERE album.album_id = NEW.album_id;
END//

DELIMITER ;

-- ======================================================
-- TRIGGER 2: Add stock when vendor inventory is received
-- ======================================================

-- This trigger fires AFTER inserting a row into invoice_items_details
-- It increases album stock based on quantity bought from vendor

DROP TRIGGER IF EXISTS Stock_Update;
DELIMITER //

CREATE TRIGGER Stock_Update
AFTER INSERT ON invoice_items_details
FOR EACH ROW
BEGIN
    UPDATE album
    SET album_copies_available = album_copies_available + NEW.quantity_bought
    WHERE album.album_id = NEW.album_id;
END//

DELIMITER ;
