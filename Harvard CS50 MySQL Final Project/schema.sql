/* REMAINED TO DO
[X] today (January 07, 2025) Finish the log of procedures to find where is the error of the add_product_to_cart


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

-- CREATE DATABASE `CS50`;
-- USE `CS50`;

CREATE TABLE IF NOT EXISTS `product` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(70) NOT NULL,
    `description` TEXT,
    `unit_price_USD` DECIMAL(12 , 2) NOT NULL,
    `datetime_created` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
	`datetime_last_changed` DATETIME(0) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
);



CREATE TABLE IF NOT EXISTS `customer`(
    `id` INT AUTO_INCREMENT,
    `first_name` VARCHAR(70) NOT NULL,
    `last_name` VARCHAR(70) NOT NULL,
    `email` VARCHAR(70) UNIQUE,
    `mobile_number` VARCHAR(20) UNIQUE,
    `datetime_created` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    `datetime_last_changed` DATETIME(0) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`)
);



CREATE TABLE IF NOT EXISTS `address`(
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



CREATE TABLE IF NOT EXISTS `order`(
    `id` INT AUTO_INCREMENT,
    `customer_id` INT,
    `address_id` INT,
    `status` ENUM('new', 'payed', 'shipped') NOT NULL,
    `deleted` BIT DEFAULT 0, -- the value of 1 (one) corresponds to 'yes', whereas 0 (zero) corresponds to 'no'
    `datetime_created` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    `datetime_last_changed` DATETIME(0) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`address_id`) REFERENCES `address`(`id`),
    FOREIGN KEY(`customer_id`) REFERENCES `customer`(`id`)
);



CREATE TABLE IF NOT EXISTS `cart`(
    `id` INT AUTO_INCREMENT,
    `order_id` INT,
    `product_id` INT,
    `quantity`  SMALLINT UNSIGNED DEFAULT 1,
    `unit_price`  DECIMAL(12 , 2 ) NOT NULL DEFAULT 1, -- DEFAULT 1 because cannot be NULL
    `unit_price_final`  DECIMAL(12 , 2 ) NOT NULL DEFAULT 1,
    `datetime_created` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    `datetime_last_changed` DATETIME(0) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`order_id`) REFERENCES `order`(`id`)
);



CREATE TABLE IF NOT EXISTS `log_cart`(
    `id` INT AUTO_INCREMENT,
    `cart_id` INT,
    `action` VARCHAR(15),
    `description` TINYTEXT,
    `datetime` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`cart_id`) REFERENCES `cart`(`id`)
);



CREATE TABLE IF NOT EXISTS `log_address`(
    `id` INT AUTO_INCREMENT,
    `address_id` INT,
    `action` VARCHAR(15),
    `description` TINYTEXT,
    `datetime` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`address_id`) REFERENCES `address`(`id`)
);



CREATE TABLE IF NOT EXISTS `log_order`(
    `id` INT AUTO_INCREMENT,
    `order_id` INT,
    `action` VARCHAR(15),
    `description` TINYTEXT,
    `datetime` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`order_id`) REFERENCES `order`(`id`)
);


CREATE TABLE `log_procedure`(
    `id` INT AUTO_INCREMENT,
    `procedure_name` VARCHAR(50),
    `description` TINYTEXT,
    `datetime` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`)
);


/* VIEWS */

-- get line prices

CREATE VIEW `product_line_price` AS
SELECT 
	`order_id`, 
    `product_id`, 
    SUM(`quantity`),
    SUM(`quantity` * `product`.`unit_price_USD`)  AS `line_price`
FROM  `cart`
JOIN `product` ON `product`.`id` = `cart`.`product_id`
GROUP BY `order_id`, `product_id`
ORDER BY `order_id` ASC, `product_id` ASC;


-- SELECT * FROM `product_line_price` LIMIT 10;
-- DROP VIEW `product_line_price`;


-- see statistics by products sold

CREATE VIEW `stats_by_product` AS
SELECT 
	`product_id`, 
    SUM(`quantity`) AS `total_quantity`,
	SUM(`quantity` * `product`.`unit_price_USD`)  AS `total_price`
FROM `cart`
JOIN `product` ON `product`.`id` = `cart`.`product_id`
GROUP BY `product_id`
ORDER BY `total_price` DESC, `total_quantity` DESC, `product_id` ASC;



-- see statistics by orders

CREATE VIEW `stats_by_order` AS
SELECT
    `order_id`,
	COUNT(`cart`.`product_id`) AS `product_variaty`, 
    SUM(`cart`.`quantity`) AS `item_quantity`,
    SUM(`quantity` * `product`.`unit_price_USD`)  AS `order_total_price`,
    ROUND(SUM(`quantity` * `product`.`unit_price_USD`) / SUM(`cart`.`quantity`),2) AS `order_avg_price`,
    GREATEST(MAX(`cart`.`datetime_last_changed`), `order`.`datetime_last_changed`) AS `datetime_last_changed`
FROM  `cart`
JOIN `product` ON `product`.`id` = `cart`.`product_id`
JOIN `order` ON `order`.`id` = `cart`.`order_id`
GROUP BY `cart`.`order_id`
ORDER BY `order_total_price` DESC, `item_quantity` DESC, `order_id` ASC;


/* TRIGGERS */

DELIMITER $$

-- triggers on changes to the `order` table

CREATE TRIGGER `trigger_log_update_order`
	AFTER UPDATE ON `order`
	FOR EACH ROW
	BEGIN
    
        -- Check on address_id column
		IF NEW.`address_id` != OLD.`address_id` 
        THEN
			INSERT INTO `log_order`(`action`, `order_id`, `description`) VALUES
			(CONCAT('UPDATE'), OLD.`id`, CONCAT('new address_id = ', NEW.`address_id`, ', old address_id = ', OLD.`address_id`));
		END IF;
        
        -- Check on customer_id column
		IF NEW.`customer_id` != OLD.`customer_id` 
        THEN
			INSERT INTO `log_order`(`action`, `order_id`, `description`) VALUES
			(CONCAT('UPDATE'), OLD.`id`, CONCAT('new customer_id = ', NEW.`customer_id`, ', old customer_id = ', OLD.`customer_id`));
		END IF;
            
        -- Check on status column
		IF NEW.`status` != OLD.`status` 
        THEN
			INSERT INTO `log_order`(`action`, `order_id`, `description`) VALUES
			(CONCAT('UPDATE'), OLD.`id`, CONCAT('new status = ', NEW.`status`, ', old status = ', OLD.`status`));
		END IF;
        
         -- Check on deleted column
		IF NEW.`deleted` != OLD.`deleted` 
        THEN
			INSERT INTO `log_order`(`action`, `order_id`, `description`) VALUES
			(CONCAT('Order No = ', OLD.`id`, ' is deleted with the status = ', OLD.`status`, ' for the customer No = ', OLD.`customer_id`, ' supposed to be shipped at the address_id = ', OLD.`address_id`));
		END IF;  
        
	END$$

CREATE TRIGGER `trigger_log_insert_order`
	AFTER INSERT ON `order`
	FOR EACH ROW
	BEGIN
       	INSERT INTO `log_order`(`action`, `order_id`, `description`) VALUES
		(
        CONCAT('INSERT'), 
        NEW.`id`, 
        CONCAT('Order No = ', NEW.`id`, ' is created with the status = ', NEW.`status`, ' for the customer No = ', NEW.`customer_id`, ' to be shipped at the address_id = ', NEW.`address_id`)
		);
	END$$

-- triggers on changes to the `order` table do not exist. Any changes to the `cart` table are traced inside `log_cart` table directly using the queries of the respective procedures on carts

DELIMITER $$

-- This trigger is commented, because the actual price is directly managed by the Procedure `add_product_to_cart`
-- CREATE TRIGGER `trigger_log_insert_`cart`
-- 	AFTER INSERT ON `cart`
-- 	FOR EACH ROW
-- 	BEGIN
--        	UPDATE `cart`
-- 		SET `unit_price`  = (SELECT `unit_price_USD` FROM `product` WHERE `product`.`id` = NEW.`product_id`)
--         WHERE `id` = NEW.`id`;
-- 	END$$



/* PROCEDURES */

-- the procedure will add a new product to an order (cart)
-- if the order is not in a modifiable state, then a new order will be created
-- if order is in a allowed state AND the product oready exists in its cart, then the request is denied

CREATE PROCEDURE `add_product_to_cart` (
	IN `p_customer_id` INT, 
    IN `p_product_id` INT, 
    IN `p_quantity` INT)
BEGIN
	DECLARE `var_unit_price` DECIMAL(12 , 2);
    DECLARE `var_order_status` TINYTEXT;
    DECLARE `var_order` INT;
    
    -- Extract the current price into a variable
    SELECT `unit_price_USD` INTO `var_unit_price` FROM `product` WHERE `id` = `p_product_id`;
    
    -- Extract the order status into a variable
    -- SELECT `status` INTO `var_order_status` FROM `order` WHERE `id` = `p_order_id`;
    
    -- Extract the order in the status 'new' for the current customer
    SELECT `id` INTO `var_order` FROM `order` WHERE `customer_id` = `p_customer_id` AND `status` = 'new';
    
    -- Check either the Customer exists
    IF `p_customer_id` IN (SELECT `id` FROM `customer`) THEN
    
    -- Log the results of this step
    INSERT INTO `log_procedure` (`procedure_name`, `description`) VALUES
	(
		CONCAT('add_product_to_cart', ' C = ', `p_customer_id`, ' P = ', `p_product_id`,' Q = ', `p_quantity`),
        CONCAT('The customer exists')
    );
    
		-- Check either a valid order exists
		IF 	`var_order` IS NOT NULL THEN
        
        -- Log the results of this step
		INSERT INTO `log_procedure` (`procedure_name`, `description`) VALUES
		(
			CONCAT('add_product_to_cart', ' C = ', `p_customer_id`, ' P = ', `p_product_id`,' Q = ', `p_quantity`),
			CONCAT('The order exists AND is in the -new- state. ', 'var_order = ', `var_order`)
		);
			
            -- A vadid order exists. Now let's check either the desired product already doesn't exist yet within the cart
            IF `p_product_id` NOT IN (SELECT `product_id` FROM `cart` WHERE `order_id` = `var_order`) THEN
            
                -- Let's conduct the addition of a product to the cart
                INSERT INTO `cart` (`order_id`, `product_id`, `quantity`, `unit_price`) VALUES
                (`var_order`, `p_product_id`, `p_quantity`, `var_unit_price`);
                
                -- Log the results of this step
				INSERT INTO `log_procedure` (`procedure_name`, `description`) VALUES
				(
					CONCAT('add_product_to_cart', ' C = ', `p_customer_id`, ' P = ', `p_product_id`,' Q = ', `p_quantity`),
					CONCAT('This is a new product. Thus a new record was added to the -cart- table, id = ', 
                        (SELECT `id` FROM `cart` 
                        WHERE ((`order_id` = `var_order`) AND (`product_id` = `p_product_id`)) ORDER BY `datetime_created` DESC LIMIT 1)
                        )
				);
                
            ELSE
            
				-- Log the results of this step
				INSERT INTO `log_procedure` (`procedure_name`, `description`) VALUES
				(
					CONCAT('add_product_to_cart', ' C = ', `p_customer_id`, ' P = ', `p_product_id`,' Q = ', `p_quantity`),
					CONCAT('Such Product is already within the cart')
				);
            
                SIGNAL SQLSTATE '45001' -- Custom error code
                SET MESSAGE_TEXT = 'Such Product is already within the cart';

            END IF;
			
		-- The a valid order doesn't exist. We create a new order and add a product into it
		ELSE
            -- Create a new order
			INSERT INTO `order`(`customer_id`, `status`) VALUES
            (`p_customer_id`, 'new');

            -- Record the id of the newly order into a variable
            SELECT `id` INTO `var_order` FROM `order` WHERE `customer_id` = `p_customer_id` AND `status` = 'new' ORDER BY `id` DESC LIMIT 1;
            
            -- Log the results of this step
				INSERT INTO `log_procedure` (`procedure_name`, `description`) VALUES
				(
					CONCAT('add_product_to_cart', ' C = ', `p_customer_id`, ' P = ', `p_product_id`,' Q = ', `p_quantity`),
					CONCAT('The Customer does not have yet an order in the -new- state. Thus a new order is created. ', 'var_order = ', `var_order`)
				);

            -- Add the product to that newly created order
            INSERT INTO `cart` (`order_id`, `product_id`, `quantity`, `unit_price`) VALUES
            (`var_order`, `p_product_id`, `p_quantity`, `var_unit_price`);
            
            -- Log the results of this step
				INSERT INTO `log_procedure` (`procedure_name`, `description`) VALUES
				(
					CONCAT('add_product_to_cart', ' C = ', `p_customer_id`, ' P = ', `p_product_id`,' Q = ', `p_quantity`),
					CONCAT('This is a new product.', ' cart_id = ', 
                        (SELECT `id` FROM `cart` 
                        WHERE ((`order_id` = `var_order`) AND (`product_id` = `p_product_id`)) ORDER BY `datetime_created` DESC LIMIT 1),
                        ' is created'
                        )
				);

		END IF;
    
    -- The Customer doesn't exist. We exit the procedure with an error message
    ELSE
    
        -- Log the results of this step
				INSERT INTO `log_procedure` (`procedure_name`, `description`) VALUES
				(
					CONCAT('add_product_to_cart', ' C = ', `p_customer_id`, ' P = ', `p_product_id`,' Q = ', `p_quantity`),
					CONCAT('Such Customer does NOT exist')
				);
    
		SIGNAL SQLSTATE '45004' -- Custom error code
		SET MESSAGE_TEXT = 'Such Customer does NOT exist';
        
    END IF;
END$$

DELIMITER ;


CALL `add_product_to_cart`(2,8,3);

SELECT * FROM `cart` JOIN `order` ON `order`.`id` = `cart`.`order_id`;

DROP PROCEDURE `add_product_to_cart`;
SELECT * FROM `order`;
SELECT * FROM `cart`;
SELECT `status` FROM `order` WHERE `id` = 12;



/*
This procedure :
- adjusts the quantity of product a within an order AND 
- updates the price at the cart to the current price for the product modified
*/

DELIMITER $$

CREATE PROCEDURE `modify_product_quantity_at_cart` (
	IN `p_order_id` INT, -- existing order
    IN `p_product_id` INT, -- existing product
    IN `p_quantity` INT) -- new quantity product
BEGIN
	DECLARE `var_unit_price` DECIMAL(12 , 2);
    DECLARE `var_order_status` TINYTEXT;
    
    -- Extract the current product price
    SELECT `unit_price_USD` INTO `var_unit_price` FROM `product` WHERE `id` = `p_product_id`;
    -- Extract the current order status
    SELECT `status` INTO `var_order_status` FROM `order` WHERE `id` = `p_order_id`;
    
    -- Check either the order exists
    IF `var_order_status` IS NOT NULL THEN
		
        -- Check either the status is 'new'
        IF `var_order_status` = 'new' THEN
        
			-- Check either the new quantity is different then the existing one
			IF `p_quantity` != (SELECT `quantity` FROM `cart` WHERE `order_id` = `p_order_id` AND `product_id` = `p_product_id`) THEN
			
				IF `p_product_id` IN (SELECT `product_id` FROM `cart` WHERE `order_id` = `p_order_id`) THEN
					UPDATE `cart`
					SET `quantity` = `p_quantity`, `unit_price` = `var_unit_price`
					WHERE `order_id` = `p_order_id` AND `product_id` = `p_product_id`;
					
				ELSE 
					SIGNAL SQLSTATE '45000' -- Custom error code
					SET MESSAGE_TEXT = 'Such Product is NOT within the Order';
				END IF;
			
			ELSE
				SIGNAL SQLSTATE '45000' -- Custom error code
				SET MESSAGE_TEXT = 'The new quantity is the same as the existing one';
			END IF;
        
		ELSE
			SIGNAL SQLSTATE '45000' -- Custom error code
			SET MESSAGE_TEXT = 'Such an Order exists, but is not in the state -new-';
		END IF;
        
    ELSE
		SIGNAL SQLSTATE '45000' -- Custom error code
			SET MESSAGE_TEXT = 'Such Order does NOT exist';
	END IF;
END$$

DELIMITER ;

DROP PROCEDURE `modify_product_quantity_at_cart`;
SELECT * FROM `cart`;
SELECT * FROM `order`;
CALL `modify_product_quantity_at_cart`(2,3,2); 

/*
This procedure :
- removes a product from a cart
*/

DELIMITER $$

CREATE PROCEDURE `remove_product_from_cart` (
	IN `p_order_id` INT, -- existing order
    IN `p_product_id` INT) -- existing product
    
BEGIN
	DECLARE `var_order_status` TINYTEXT;
    
    -- Extract the current order status
    SELECT `status` INTO `var_order_status` FROM `order` WHERE `id` = `p_order_id`;
    
    -- Check either the order exists
    IF `var_order_status` IS NOT NULL THEN
		
        -- Check either the status is 'new'
        IF `var_order_status` = 'new' THEN
			
				IF `p_product_id` IN (SELECT `product_id` FROM `cart` WHERE `order_id` = `p_order_id`) THEN
					UPDATE `cart`
					SET `quantity` = `p_quantity`, `unit_price` = `var_unit_price`
					WHERE `order_id` = `p_order_id` AND `product_id` = `p_product_id`;
					
				ELSE 
					SIGNAL SQLSTATE '45000' -- Custom error code
					SET MESSAGE_TEXT = 'Such Product is NOT within the Order';
				END IF;
        
		ELSE
			SIGNAL SQLSTATE '45000' -- Custom error code
			SET MESSAGE_TEXT = 'Such an Order exists, but is not in the state -new-';
		END IF;
        
    ELSE
		SIGNAL SQLSTATE '45000' -- Custom error code
			SET MESSAGE_TEXT = 'Such Order does NOT exist';
	END IF;
END$$

DELIMITER ;

CALL `remove_product_from_cart`(2,3); 





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
SELECT * FROM `product_line_price` LIMIT 10;
DROP VIEW `product_line_price`;

SELECT * FROM `stats_by_product` LIMIT 10;
DROP VIEW `stats_by_product`;

SELECT * FROM `stats_by_order` LIMIT 10;
DROP VIEW `stats_by_order`;



-- =========== SAFE PROCEDURE (NO CHECK EITHER THE PRODUCT ALREADY EXISTS WITHIN THE ORDER)
-- CREATE PROCEDURE `add_product_to_cart` (
-- 	IN `p_order_id` INT, 
--     IN `p_product_id` INT, 
--     IN `p_quantity` INT)
-- BEGIN
-- 	DECLARE `p_unit_price` DECIMAL(12 , 2 );
--     DECLARE `var_order_status` ENUM('new', 'payed', 'shipped');
--     
--     -- Extract the current price into a variable
--     SELECT `unit_price_USD` INTO `p_unit_price` FROM `product` WHERE `id` = `p_product_id`;
--     -- Extract the order status into a variable
--     SELECT `status` INTO `var_order_status` FROM `order` WHERE `id` = `p_order_id`;
--     
--     -- Check either the order exists
-- 	IF 	`var_order_status` IS NOT NULL THEN
--     
-- 		-- Exists. Then let's check either the order is in the allowed status (addition to the basket is allowed only for the orders in the status 'new')
-- 		IF `var_order_status` = 'new' THEN
-- 			
--             -- In allowed state. Let's conduct the addition of a product to a basket
-- 			INSERT INTO `cart` (`order_id`, `product_id`, `quantity`, `unit_price`) VALUES
-- 			(`p_order_id`, `p_product_id`, `p_quantity`, `p_unit_price`);
-- 		ELSE
-- 			SIGNAL SQLSTATE '45000' -- Custom error code
-- 			SET MESSAGE_TEXT = 'Such Order is NOT in a allowed state';
-- 		END IF;
--         
-- 	-- The order doesn't exist. We exit the procedure with the right error message
--     ELSE
-- 		SIGNAL SQLSTATE '45000' -- Custom error code
-- 		SET MESSAGE_TEXT = 'Such Order does NOT exist';	
-- 	END IF;
--     
-- END$$