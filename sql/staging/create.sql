-- MySQL Workbench Forward Engineering


SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Music_Store_DB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Music_Store_DB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Music_Store_DB` DEFAULT CHARACTER SET utf8 ;
USE `Music_Store_DB` ;

-- -----------------------------------------------------
-- Table `Music_Store_DB`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS customer;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`customer` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(45) NOT NULL,
  `lastname` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(15) NOT NULL,
  `age` INT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `billing_address_id` INT NOT NULL,
  `shipping_address_id` INT NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) ,
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`artist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS artist;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`artist` (
  `artist_id` INT NOT NULL AUTO_INCREMENT,
  `artist_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`artist_id`),
  UNIQUE INDEX `name_UNIQUE` (`artist_name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS genre;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`genre` (
  `genre_id` INT NOT NULL AUTO_INCREMENT,
  `genre_name` VARCHAR(30) NOT NULL,
  `genre_description` VARCHAR(140) NOT NULL,
  PRIMARY KEY (`genre_id`),
  UNIQUE INDEX `genre_name_UNIQUE` (`genre_name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`album`
-- -----------------------------------------------------
DROP TABLE IF EXISTS album;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`album` (
  `album_id` INT NOT NULL AUTO_INCREMENT,
  `album_name` VARCHAR(45) NOT NULL,
  `artist_id` INT NOT NULL,
  `album_copies_available` INT NOT NULL,
  `album_price` DECIMAL(10,2) NOT NULL,
  `copyright_year` INT NOT NULL,
  `genre_id` INT NOT NULL,
  PRIMARY KEY (`album_id`),
  UNIQUE INDEX `album_name_UNIQUE` (`album_name` ASC) ,
  INDEX `fk_album_genre1_idx` (`genre_id` ASC) ,
  CONSTRAINT `fk_album_artist`
    FOREIGN KEY (`artist_id`)
    REFERENCES `Music_Store_DB`.`artist` (`artist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_album_genre1`
    FOREIGN KEY (`genre_id`)
    REFERENCES `Music_Store_DB`.`genre` (`genre_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`media_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS media_type;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`media_type` (
  `media_type_id` INT NOT NULL AUTO_INCREMENT,
  `media_type_name` VARCHAR(18) NOT NULL,
  PRIMARY KEY (`media_type_id`),
  UNIQUE INDEX `media_type_name_UNIQUE` (`media_type_name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`track`
-- -----------------------------------------------------
DROP TABLE IF EXISTS track;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`track` (
  `track_id` INT NOT NULL AUTO_INCREMENT,
  `track_name` VARCHAR(45) NOT NULL,
  `album_id` INT NOT NULL,
  `track_length` INT NOT NULL,
  `media_type_id` INT NOT NULL,
  PRIMARY KEY (`track_id`),
  UNIQUE INDEX `track_name_UNIQUE` (`track_name` ASC) ,
  INDEX `fk_track_media_type1_idx` (`media_type_id` ASC) ,
  CONSTRAINT `fk_track_album1`
    FOREIGN KEY (`album_id`)
    REFERENCES `Music_Store_DB`.`album` (`album_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_track_media_type1`
    FOREIGN KEY (`media_type_id`)
    REFERENCES `Music_Store_DB`.`media_type` (`media_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`order_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS order_type;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`order_type` (
  `order_type_id` INT NOT NULL AUTO_INCREMENT,
  `order_type_name` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`order_type_id`),
  UNIQUE INDEX `order_type_name_UNIQUE` (`order_type_name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`orders`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS orders;
-- CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`orders` (
--   `order_id` INT NOT NULL AUTO_INCREMENT,
--   `order_type_id` INT NOT NULL,
--   `customer_id` INT NOT NULL,
--   `order_date` DATETIME NOT NULL,
--   PRIMARY KEY (`order_id`),
--   INDEX `fk_orders_order_type1_idx` (`order_type_id` ASC) ,
--   CONSTRAINT `fk_orders_customer1`
--     FOREIGN KEY (`customer_id`)
--     REFERENCES `Music_Store_DB`.`customer` (`customer_id`)
--     ON DELETE NO ACTION
--     ON UPDATE NO ACTION,
--   CONSTRAINT `fk_orders_order_type1`
--     FOREIGN KEY (`order_type_id`)
--     REFERENCES `Music_Store_DB`.`order_type` (`order_type_id`)
--     ON DELETE NO ACTION
--     ON UPDATE NO ACTION)
-- ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `Music_Store_DB`.`orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`orders` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `order_type_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  `order_date` DATETIME NOT NULL,
    `store_id` INT NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_orders_order_type1_idx` (`order_type_id` ASC),
  INDEX `fk_orders_store1_idx` (`store_id` ASC),
  CONSTRAINT `fk_orders_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `Music_Store_DB`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_order_type1`
    FOREIGN KEY (`order_type_id`)
    REFERENCES `Music_Store_DB`.`order_type` (`order_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_store1`
    FOREIGN KEY (`store_id`)
    REFERENCES `Music_Store_DB`.`store_location` (`store_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `Music_Store_DB`.`order_items`
-- -----------------------------------------------------
DROP TABLE IF EXISTS order_items;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`order_items` (
  `order_items_id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `unit_price` DECIMAL(10,2) NOT NULL,
  `quantity_to_buy` INT NOT NULL,
  `album_id` INT NOT NULL,
  PRIMARY KEY (`order_items_id`),
  INDEX `fk_order_items_orders1_idx` (`order_id` ASC) ,
  INDEX `fk_order_items_album1_idx` (`album_id` ASC) ,
  CONSTRAINT `fk_order_items_orders1`
    FOREIGN KEY (`order_id`)
    REFERENCES `Music_Store_DB`.`orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_items_album1`
    FOREIGN KEY (`album_id`)
    REFERENCES `Music_Store_DB`.`album` (`album_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS country;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`country` (
  `country_id` INT NOT NULL AUTO_INCREMENT,
  `country_name` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`country_id`),
  UNIQUE INDEX `country_name_UNIQUE` (`country_name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`province`
-- -----------------------------------------------------
DROP TABLE IF EXISTS province;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`province` (
  `province_id` INT NOT NULL AUTO_INCREMENT,
  `province_name` VARCHAR(25) NOT NULL,
  `country_id` INT NOT NULL,
  PRIMARY KEY (`province_id`),
  UNIQUE INDEX `province_name_UNIQUE` (`province_name` ASC) ,
  INDEX `fk_province_country1_idx` (`country_id` ASC) ,
  CONSTRAINT `fk_province_country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `Music_Store_DB`.`country` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`city`
-- -----------------------------------------------------
DROP TABLE IF EXISTS city;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`city` (
  `city_id` INT NOT NULL AUTO_INCREMENT,
  `city_name` VARCHAR(25) NOT NULL,
  `province_id` INT NOT NULL,
  PRIMARY KEY (`city_id`),
  UNIQUE INDEX `city_name_UNIQUE` (`city_name` ASC) ,
  INDEX `fk_city_province1_idx` (`province_id` ASC) ,
  CONSTRAINT `fk_city_province1`
    FOREIGN KEY (`province_id`)
    REFERENCES `Music_Store_DB`.`province` (`province_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`customer_address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS customer_address;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`customer_address` (
  `address_id` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NOT NULL,
  `line1` VARCHAR(60) NOT NULL,
  `line2` VARCHAR(60) NULL DEFAULT NULL,
  `city_id` INT NOT NULL,
  `pincode` VARCHAR(12) NOT NULL,
  `disabled` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`address_id`),
  INDEX `fk_address_city1_idx` (`city_id` ASC) ,
  INDEX `fk_customer_address_customer1_idx` (`customer_id` ASC) ,
  CONSTRAINT `fk_address_city1`
    FOREIGN KEY (`city_id`)
    REFERENCES `Music_Store_DB`.`city` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_customer_address_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `Music_Store_DB`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`vendor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS vendor;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`vendor` (
  `vendor_id` INT NOT NULL AUTO_INCREMENT,
  `vendor_name` VARCHAR(45) NOT NULL,
  `address_line1` VARCHAR(60) NOT NULL,
  `address_line2` VARCHAR(60) NULL DEFAULT NULL,
  `city_id` INT NOT NULL,
  `pincode` VARCHAR(12) NOT NULL,
  `phone` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`vendor_id`),
  UNIQUE INDEX `vendor_name_UNIQUE` (`vendor_name` ASC) ,
  INDEX `fk_vendor_city1_idx` (`city_id` ASC) ,
  CONSTRAINT `fk_vendor_city1`
    FOREIGN KEY (`city_id`)
    REFERENCES `Music_Store_DB`.`city` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`Invoices`
-- -----------------------------------------------------
DROP TABLE IF EXISTS invoices;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`Invoices` (
  `Invoice_id` INT NOT NULL AUTO_INCREMENT,
  `Invoice_no` VARCHAR(45) NOT NULL,
  `Invoice_Date` DATETIME NOT NULL,
  `vendor_id` INT NOT NULL,
  PRIMARY KEY (`Invoice_id`),
  INDEX `fk_Invoices_vendor1_idx` (`vendor_id` ASC) ,
  CONSTRAINT `fk_Invoices_vendor1`
    FOREIGN KEY (`vendor_id`)
    REFERENCES `Music_Store_DB`.`vendor` (`vendor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Music_Store_DB`.`invoice_items_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS invoice_items_details;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`invoice_items_details` (
  `invoice_item_id` INT NOT NULL AUTO_INCREMENT,
  `invoice_id` INT NOT NULL,
  `quantity_bought` INT NOT NULL,
  `item_price` DECIMAL(10,2) NOT NULL,
  `album_id` INT NOT NULL,
  PRIMARY KEY (`invoice_item_id`),
  INDEX `fk_Invoice_items_details_Invoices1_idx` (`invoice_id` ASC) ,
  INDEX `fk_Invoice_items_details_album1_idx` (`album_id` ASC) ,
  CONSTRAINT `fk_Invoice_items_details_Invoices1`
    FOREIGN KEY (`invoice_id`)
    REFERENCES `Music_Store_DB`.`Invoices` (`Invoice_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Invoice_items_details_album1`
    FOREIGN KEY (`album_id`)
    REFERENCES `Music_Store_DB`.`album` (`album_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Music_Store_DB`.`store_location`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `store_location`;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`store_location` (
  `store_id` INT NOT NULL,
  `city_id` INT,
  `province_id` INT,
  `country_id` INT,
  PRIMARY KEY (`store_id`),
  INDEX `fk_store_city_idx` (`city_id` ASC),
  INDEX `fk_store_province_idx` (`province_id` ASC),
  INDEX `fk_store_country_idx` (`country_id` ASC),
  CONSTRAINT `fk_store_city`
    FOREIGN KEY (`city_id`)
    REFERENCES `Music_Store_DB`.`city` (`city_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_store_province`
    FOREIGN KEY (`province_id`)
    REFERENCES `Music_Store_DB`.`province` (`province_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_store_country`
    FOREIGN KEY (`country_id`)
    REFERENCES `Music_Store_DB`.`country` (`country_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Music_Store_DB`.`famous_artists`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `famous_artists`;
CREATE TABLE IF NOT EXISTS `Music_Store_DB`.`famous_artists` (
  `icon_id` INT NOT NULL,
  `artist_id` INT NOT NULL,
  `artist_name` VARCHAR(255),
  `num_albums` INT,
  `total_copies` INT,
  `average_price` DECIMAL(5,2),
  `first_album_year` INT,
  `last_album_year` INT,
  PRIMARY KEY (`icon_id`),
  INDEX `fk_famous_artist_idx` (`artist_id` ASC),
  CONSTRAINT `fk_famous_artist`
    FOREIGN KEY (`artist_id`)
    REFERENCES `Music_Store_DB`.`artist` (`artist_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
