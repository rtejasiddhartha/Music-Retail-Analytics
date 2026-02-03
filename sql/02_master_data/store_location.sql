ALTER TABLE orders
DROP FOREIGN KEY fk_orders_store1;

ALTER TABLE store_location
DROP FOREIGN KEY fk_store_city;

ALTER TABLE store_location
ADD CONSTRAINT fk_store_city
FOREIGN KEY (city_id)
REFERENCES city(city_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE store_location
ADD CONSTRAINT fk_store_province
FOREIGN KEY (province_id)
REFERENCES province(province_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE store_location
ADD CONSTRAINT fk_store_country
FOREIGN KEY (country_id)
REFERENCES country(country_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;


INSERT INTO store_location (store_id, city_id, province_id, country_id) VALUES
-- 🇨🇦 Canada Stores
(1, 47, 9, 1),   -- Toronto, Ontario, Canada
(2, 49, 9, 1),   -- Brampton, Ontario, Canada
(3, 73, 11, 1),  -- Brossard, Quebec, Canada
(4, 24, 3, 1),   -- Brandon, Manitoba, Canada
(5, 21, 9, 1),   -- Abbotsford, Ontario, Canada
(6, 75, 11, 1),  -- Laval, Quebec, Canada

-- 🇺🇸 United States Stores
(7, 145, 24, 2), -- Hilo, Hawaii, USA
(8, 105, 18, 2), -- Berkeley, California, USA
(9, 219, 40, 2), -- Bellevue, Washington, USA
(10, 310, 60, 2),-- Omaha, Nebraska, USA
(11, 318, 62, 2),-- Green Bay, Wisconsin, USA
(12, 311, 60, 2),-- Lincoln, Nebraska, USA
(13, 108, 18, 2),-- Oakland, California, USA
(14, 82, 14, 2), -- Birmingham, Alabama, USA
(15, 160, 27, 2);-- Evansville, Indiana, USA

