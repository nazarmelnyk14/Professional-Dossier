SELECT * FROM `cart`;
SELECT * FROM `order`;
SELECT * FROM `customer`;
SELECT * FROM `product`;
SELECT * FROM `log_customer`;
SELECT * FROM `log_cart`;
SELECT * FROM `log_order`;
SELECT * FROM `log_address`;
SELECT * FROM `log_product`;

UPDATE `product`
SET `unit_price_USD` = 510
WHERE `id` = 2;

CALL `add_product_to_cart` (7,2,1);
CALL `modify_product_quantity_at_cart` (10,2,7);
CALL `remove_product_from_cart` (10,2);
DROP PROCEDURE `remove_product_from_cart`;

SELECT * FROM `customer` WHERE `mobile_number` = '33617382690';

INSERT INTO `customer`(`first_name`, `last_name`, `email`, `mobile_number`) VALUES
('Taras', 'Kniaz', '', '');

UPDATE `customer`
SET `mobile_number` = '380983762219'
WHERE `id` = 17;

DELETE FROM `customer`
WHERE `mobile_number` = '33617382690';


Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`cs50`.`log_customer`, CONSTRAINT `log_customer_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`))

ALTER TABLE `cart`
MODIFY `unit_price` DECIMAL(12 , 2 );

ALTER TABLE `product`
ALTER COLUMN `out of stock` `out_of_stock` TINYINT(1) DEFAULT FALSE;

USE CS50;
ALTER TABLE `cart`
DROP COLUMN `unit_price_final`;

DESCRIBE `product`;


-- SELECT * FROM `product_line_price` LIMIT 10;
-- DROP VIEW `product_line_price`;

/* TESTING QUERIES */ 

SELECT * FROM `order`;
DESCRIBE `order`;
TRUNCATE TABLE `order`;

SELECT * FROM `cart`;


SELECT * FROM `cart`
JOIN `product` ON `product`.`id` = `cart`.`product_id` 
WHERE `cart`.`order_id` = 2;

UPDATE `order`
	SET `status` = 'shipped'
	WHERE `id` = 10;

UPDATE `order`
	SET `address_id` = 4
	WHERE `id` = 6;
    
UPDATE `cart`
	SET `quantity` = 4
	WHERE `id` = 6;
    
INSERT INTO `order` (`customer_id`, `address_id`, `status`) VALUES
-- (1, 1, 'new'),
-- (2, 2, 'payed'),
-- (3, 3, 'shipped'),
-- (4, 4, 'new'),
-- (5, 5, 'payed'),
-- (6, 6, 'shipped'),
-- (7, 7, 'new'),
-- (8, 8, 'payed'),
-- (9, 9, 'shipped'),
(8, 8, 'new'),
(1, 2, 'payed');

DELETE FROM `order` WHERE `id` = 12;

SELECT * FROM `log_order`;

-- Drop a trigger
DROP TRIGGER `trigger_log_insert_order`;

-- see the triggerss
SELECT TRIGGER_SCHEMA, TRIGGER_NAME, EVENT_MANIPULATION, EVENT_OBJECT_TABLE, ACTION_TIMING, ACTION_STATEMENT
FROM INFORMATION_SCHEMA.TRIGGERS
WHERE TRIGGER_SCHEMA = 'project';

-- 
CALL `remove_product_from_cart`(2,3); 
-- 

SELECT * FROM `product_line_price` LIMIT 10;
DROP VIEW `product_line_price`;

SELECT * FROM `stats_by_product` LIMIT 10;
DROP VIEW `stats_by_product`;

SELECT * FROM `stats_by_order` LIMIT 10;
DROP VIEW `stats_by_order`;
