/* REMAINED TO DO
[] today (January 07, 2025) Finish the log of procedures to find where is the error of the add_product_to_cart


[X] timestamps

[X] An order is to be created when the first product is added to the cart

    - User is adding a Product
    - System checks either
        - Either such a User exisits
            If YES, the either they already have an order with the status New
                If YES, then
                    - System checks either the Product Already Exists within the cart
                        If YES, then the action is denied 'Such Product is already within the cart'
                        If NO, then adds the product to the order
                If NO, then 
                    - creates an order 
                    - adds the product to the order
            If NO, then 'Such Customer doesn't exist yet'

[] Loop to insert values (random ?) into
    [] product_order
    [] address_customer

[] Log files
    [X] order
    [] product_order
    [] customer
    [] address
    [] address_customer

[] Triggers 2 per log file (UPDATE (incl DELETE) + INSERT): Product details can evolve, this should not impact the statistics
    [X] order
        [X] UPDATE (incl DELETE)
        [X] INSERT
    [X] product_order
        [X] UPDATE (incl DELETE)
        [X] INSERT -- Not necessary, because the actual price is imported using the procedure
    [] customer
    [] address
    [] address_customer


-- ADDITIONAL
[] Prepared statements to protect against SQL injections ?

*/

CREATE TABLE `product`(
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(70) NOT NULL,
    `description` TEXT,
    `unit_price_USD` DECIMAL(12,2) NOT NULL,
    `datetime_created` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    `datetime_last_changed` DATETIME(0) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`)
);


CREATE TABLE `customer`(
    `id` INT AUTO_INCREMENT,
    `first_name` VARCHAR(70) NOT NULL,
    `last_name` VARCHAR(70) NOT NULL,
    `email` VARCHAR(70) UNIQUE,
    `mobile_number` VARCHAR(20) UNIQUE,
    `datetime_created` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    `datetime_last_changed` DATETIME(0) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`)
);


CREATE TABLE `address`(
    `id` INT AUTO_INCREMENT,
    `full_address` VARCHAR(100) NOT NULL,
    `locality` VARCHAR(50) NOT NULL,
    `postal_code` VARCHAR(15) NOT NULL,
    `state` VARCHAR(50),
    `country` VARCHAR(50) NOT NULL,
    `datetime_created` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    `datetime_last_changed` DATETIME(0) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`)
);


CREATE TABLE `order`(
    `id` INT AUTO_INCREMENT,
    `customer_id` INT,
    `address_id` INT,
    `status` ENUM('new', 'payed', 'shipped') NOT NULL,
    `datetime_created` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    `datetime_last_changed` DATETIME(0) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`address_id`) REFERENCES `address`(`id`),
    FOREIGN KEY(`customer_id`) REFERENCES `customer`(`id`)
);


CREATE TABLE `product_order`(
    `id` INT AUTO_INCREMENT,
    `order_id` INT,
    `product_id` INT,
    `quantity`  SMALLINT UNSIGNED DEFAULT 1,
    `datetime_created` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    `datetime_last_changed` DATETIME(0) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`order_id`) REFERENCES `order`(`id`)
);


-- get line prices
CREATE VIEW `product_line_price` AS
SELECT `order_id`, `product_id`, `quantity`,
(`quantity` * `product`.`unit_price_USD`)  AS `line_price`
FROM  `product_order`
JOIN `product` ON `product`.`id` = `product_order`.`product_id`
ORDER BY `order_id` ASC, `product_id` ASC;



-- see statistics by products sold
CREATE VIEW `stats_by_product` AS
SELECT 
	`product_id`, 
    SUM(`quantity`) AS `total_quantity`,
	SUM(`quantity` * `product`.`unit_price_USD`)  AS `total_price`
FROM `product_order`
JOIN `product` ON `product`.`id` = `product_order`.`product_id`
GROUP BY `product_id`
ORDER BY `total_price` DESC, `total_quantity` DESC, `product_id` ASC;



-- see statistics by orders
CREATE VIEW `stats_by_order` AS
SELECT
    `order_id`,
	COUNT(`product_order`.`product_id`) AS `product_variaty`, 
    SUM(`product_order`.`quantity`) AS `item_quantity`,
    SUM(`quantity` * `product`.`unit_price_USD`)  AS `order_total_price`,
    ROUND(SUM(`quantity` * `product`.`unit_price_USD`) / SUM(`product_order`.`quantity`),2) AS `order_avg_price`,
    GREATEST(MAX(`product_order`.`datetime_last_changed`), `order`.`datetime_last_changed`) AS `datetime_last_changed`
FROM  `product_order`
JOIN `product` ON `product`.`id` = `product_order`.`product_id`
JOIN `order` ON `order`.`id` = `product_order`.`order_id`
GROUP BY `product_order`.`order_id`
ORDER BY `order_total_price` DESC, `item_quantity` DESC, `order_id` ASC;



SELECT * FROM `product_line_price` LIMIT 10;
DROP VIEW `product_line_price`;

SELECT * FROM `stats_by_product` LIMIT 10;
DROP VIEW `stats_by_product`;


SELECT * FROM `stats_by_order` LIMIT 10;
DROP VIEW `stats_by_order`;