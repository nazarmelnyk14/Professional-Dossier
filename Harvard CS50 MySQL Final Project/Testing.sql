SELECT * FROM `customer`;
SELECT * FROM `log_customer`;
SELECT * FROM `log_customer_json`;

SELECT * FROM `customer` WHERE `mobile_number` = '33617382690';

INSERT INTO `customer`(`first_name`, `last_name`, `email`, `mobile_number`) VALUES
('Taras', 'Kniaz', '', '');

UPDATE `customer`
SET `mobile_number` = '380983762219'
WHERE `id` = 17;

DELETE FROM `customer`
WHERE `mobile_number` = '33617382690';


Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`cs50`.`log_customer`, CONSTRAINT `log_customer_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`))




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
