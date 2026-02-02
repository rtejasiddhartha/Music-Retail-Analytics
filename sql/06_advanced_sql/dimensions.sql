/* =========================================================
   DIMENSION: dim_date
   Purpose:
   - Central date dimension for OLAP analysis
   - Supports year, quarter, month, weekday, weekend analysis
   - Populated using a reusable stored procedure
   ========================================================= */

-- Create dim_date table (idempotent)
CREATE TABLE IF NOT EXISTS dim_date (
  date_key        DATE PRIMARY KEY,
  year            INT NOT NULL,
  quarter         INT NOT NULL,
  month           INT NOT NULL,
  day             INT NOT NULL,
  week_of_year    INT,
  iso_week        INT,
  weekday_name    VARCHAR(10),
  weekday         INT,
  is_weekend      BOOLEAN,
  yyyymm          INT
);

/* =========================================================
   Stored Procedure: populate_dim_date
   Purpose:
   - Populate dim_date between a date range
   - Safe to re-run (idempotent)
   ========================================================= */

DELIMITER $$

DROP PROCEDURE IF EXISTS populate_dim_date$$

CREATE PROCEDURE populate_dim_date(IN p_start DATE, IN p_end DATE)
BEGIN
  DECLARE cur DATE;
  SET cur = p_start;

  WHILE cur <= p_end DO
    INSERT INTO dim_date
      (date_key, year, quarter, month, day,
       week_of_year, iso_week, weekday_name,
       weekday, is_weekend, yyyymm)
    VALUES
      (cur,
       YEAR(cur),
       QUARTER(cur),
       MONTH(cur),
       DAY(cur),
       WEEK(cur, 0),
       WEEK(cur, 3),
       DATE_FORMAT(cur, '%W'),
       WEEKDAY(cur),
       (WEEKDAY(cur) IN (5,6)),
       YEAR(cur)*100 + MONTH(cur))
    ON DUPLICATE KEY UPDATE date_key = date_key;

    SET cur = DATE_ADD(cur, INTERVAL 1 DAY);
  END WHILE;
END$$

DELIMITER ;

-- Populate dim_date for analysis window
CALL populate_dim_date('2020-01-01', '2029-12-31');

-- Validation checks
SELECT 
  COUNT(*) AS days,
  MIN(date_key) AS min_date,
  MAX(date_key) AS max_date
FROM dim_date;

SELECT * 
FROM dim_date 
ORDER BY date_key 
LIMIT 5;

/* =========================================================
   DIMENSION: dim_customer
   Purpose:
   - Denormalized customer dimension for OLAP queries
   - Combines customer + address + geography attributes
   ========================================================= */

CREATE TABLE IF NOT EXISTS dim_customer (
  customer_key     BIGINT PRIMARY KEY,
  customer_id      BIGINT,
  full_name        VARCHAR(255),
  firstname        VARCHAR(100),
  lastname         VARCHAR(100),
  phone            VARCHAR(50),
  email            VARCHAR(255),
  address_line_1   VARCHAR(255),
  address_line_2   VARCHAR(255),
  postal_code      VARCHAR(50),
  city_id          BIGINT,
  city_name        VARCHAR(150),
  province_name    VARCHAR(150),
  country_name     VARCHAR(150),
  created_at       DATETIME,
  updated_at       DATETIME,
  source_file      VARCHAR(255),
  notes            TEXT,
  INDEX (email),
  INDEX (city_id)
);

/* =========================================================
   Populate dim_customer
   Notes:
   - Uses customer_id as surrogate key (for now)
   - Safe for analytics and reporting
   ========================================================= */

INSERT INTO dim_customer (
  customer_key,
  customer_id,
  full_name,
  firstname,
  lastname,
  phone,
  email,
  address_line_1,
  address_line_2,
  postal_code,
  city_id,
  city_name,
  province_name,
  country_name,
  created_at,
  updated_at,
  source_file
)
SELECT
  c.customer_id AS customer_key,
  c.customer_id,
  TRIM(
    CONCAT(
      COALESCE(c.firstname, ''),
      CASE 
        WHEN c.firstname IS NOT NULL AND c.lastname IS NOT NULL THEN ' '
        ELSE ''
      END,
      COALESCE(c.lastname, '')
    )
  ) AS full_name,
  c.firstname,
  c.lastname,
  c.phone,
  c.email,
  ca.line1,
  ca.line2,
  ca.postal_code,
  ci.city_id,
  ci.city_name,
  p.province_name,
  co.country_name,
  NOW() AS created_at,
  NOW() AS updated_at,
  'customer_address_load' AS source_file
FROM customer c
LEFT JOIN customer_address ca ON c.customer_id = ca.customer_id
LEFT JOIN city ci ON ca.city_id = ci.city_id
LEFT JOIN province p ON ci.province_id = p.province_id
LEFT JOIN country co ON p.country_id = co.country_id;
