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
(2, 11, 2, 1),   -- Vancouver, British Columbia, Canada
(3, 66, 11, 1),  -- Montreal, Quebec, Canada
(4, 40, 7, 1),   -- Halifax, Nova Scotia, Canada
(5, 23, 3, 1),   -- Winnipeg, Manitoba, Canada
(6, 76, 12, 1),  -- Saskatoon, Saskatchewan, Canada
(7, 34, 5, 1),   -- St. John's, Newfoundland, Canada
(8, 62, 10, 1),  -- Charlottetown, PEI, Canada

-- 🇺🇸 United States Stores
(9, 100, 18, 2), -- Los Angeles, California, USA
(10, 103, 18, 2),-- San Francisco, California, USA
(11, 238, 45, 2),-- New York City, New York, USA
(12, 152, 26, 2),-- Chicago, Illinois, USA
(13, 288, 56, 2),-- Houston, Texas, USA
(14, 246, 46, 2),-- Charlotte, North Carolina, USA
(15, 308, 60, 2),-- Seattle, Washington, USA
(16, 221, 41, 2),-- Las Vegas, Nevada, USA
(17, 190, 34, 2),-- Boston, Massachusetts, USA
(18, 201, 36, 2);-- Minneapolis, Minnesota, USA
