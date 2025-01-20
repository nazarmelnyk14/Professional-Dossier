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
    
[X] Logs an JSONs
	[X] order
    [X] cart
    [X] customer
    [X] address
    [X] address_customer
    
[] User procedures

[X] Log files
    [X] order
    [X] cart
    [X] customer
    [X] address
    [X] address_customer

[X] Triggers 3 per entity

-- ADDITIONAL
[X] Remove FOREIGN KEY from log tables
	- log_cart
    - log_address
    - log_customer_address
    - log_order
    - log_customer

[X] Add `changed_by` field to the log tables and triggers associated
[X] If a product price evolves, then update all orders in the -new- state
[] Prepared statements to protect against SQL injections ?
[] SELECT statements inside JSON objects to 
[] protection against null and negative values for numerical fields
[] Simulate log in and user 

*/

-- CREATE DATABASE `CS50`;
-- USE `CS50`;

CREATE TABLE IF NOT EXISTS `product` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(70) NOT NULL,
    `description` TEXT,
    `unit_price_USD` DECIMAL(12 , 2) NOT NULL,
	`out_of_stock` BIT DEFAULT 0, -- the value of 1 (one) corresponds to 'yes', whereas 0 (zero) corresponds to 'no'
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


CREATE TABLE IF NOT EXISTS `customer_address` (
	`id` INT AUTO_INCREMENT,
    `customer_id` INT,
    `address_id` INT,
    `nickname` VARCHAR(30),
    `datetime_created` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    `datetime_last_changed` DATETIME(0) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`customer_id`) REFERENCES `customer`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`address_id`) REFERENCES `address`(`id`) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS `order`(
    `id` INT AUTO_INCREMENT,
    `customer_id` INT,
    `address_id` INT,
    `status` ENUM('new', 'payed', 'shipped') NOT NULL,
    `datetime_created` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    `datetime_last_changed` DATETIME(0) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`address_id`) REFERENCES `address`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`customer_id`) REFERENCES `customer`(`id`) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS `cart`(
    `id` INT AUTO_INCREMENT,
    `order_id` INT,
    `product_id` INT,
    `quantity`  SMALLINT UNSIGNED DEFAULT 1,
    `unit_price`  DECIMAL(12 , 2 ), -- NOT NULL DEFAULT 1 because cannot be NULL
    `datetime_created` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    `datetime_last_changed` DATETIME(0) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`order_id`) REFERENCES `order`(`id`) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS `log_cart`(
    `id` INT AUTO_INCREMENT,
    `cart_id` INT,
    `order_id` INT,
    `action` VARCHAR(15),
    `description` TINYTEXT,
    `changed_data` JSON,
    `changed_by` VARCHAR(50),
    `datetime` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `log_address`(
    `id` INT AUTO_INCREMENT,
    `address_id` INT,
    `action` VARCHAR(15),
    `description` TINYTEXT,
    `changed_data` JSON,
    `changed_by` VARCHAR(50),
    `datetime` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `log_customer_address`(
	`id` INT AUTO_INCREMENT,
    `customer_id` INT,
    `address_id` INT,
    `action` VARCHAR(15),
    `description` TINYTEXT,
    `changed_data` JSON,
    `changed_by` VARCHAR(50),
    `datetime` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `log_order`(
    `id` INT AUTO_INCREMENT,
    `order_id` INT,
    `action` VARCHAR(15),
    `description` TINYTEXT,
    `changed_data` JSON,
    `changed_by` VARCHAR(50),
    `datetime` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `log_customer`(
    `id` INT AUTO_INCREMENT,
    `customer_id` INT,
    `action` VARCHAR(15),
    `description` TINYTEXT,
    `changed_data` JSON,
    `changed_by` VARCHAR(50),
    `datetime` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `log_product`(
    `id` INT AUTO_INCREMENT,
    `product_id` INT,
    `action` VARCHAR(15),
    `description` TINYTEXT,
    `changed_data` JSON,
    `changed_by` VARCHAR(50),
    `datetime` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`)
);



CREATE TABLE `log_procedure`(
    `id` INT AUTO_INCREMENT,
    `procedure_name` VARCHAR(50),
    `description` TINYTEXT,
    `datetime` DATETIME(0) DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`)
);


CREATE TABLE `log_trigger`(
	`id` INT AUTO_INCREMENT,
    `trigger_name` VARCHAR(50),
    `action` VARCHAR(15),
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
CREATE TRIGGER `trigger_log_insert_order`
	AFTER INSERT ON `order`
	FOR EACH ROW
	BEGIN
    
       	INSERT INTO `log_order`(`order_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES
		(
        NEW.`id`,
        'INSERT',
        'Order is created',
        JSON_OBJECT(
			'id', NEW.`id`,
            'customer_id', NEW.`customer_id`,
            'address_id', NEW.`address_id`,
            'status', NEW.`status`
            ),
		USER()
		);
        
	END$$
    
    
CREATE TRIGGER `trigger_log_delete_order`
BEFORE DELETE ON `order`
FOR EACH ROW
BEGIN
	
	INSERT INTO `log_order`(`order_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES (
		OLD.`id`,
        'DELETE',
        'Order is deleted',
        JSON_OBJECT(
			'id', OLD.`id`,
            'customer_id', OLD.`customer_id`,
            'address_id', OLD.`address_id`,
            'status', OLD.`status`
            ),
        USER()
		);
    
END$$


CREATE TRIGGER `trigger_log_update_order`
	AFTER UPDATE ON `order`
	FOR EACH ROW
	BEGIN
    
		DECLARE `changed_data` JSON;
        
        -- Build the JSON object with only the changed fields
        SET `changed_data` = JSON_OBJECT();
        
        -- Check each field and add the result to the JSON object
        IF NOT (NEW.`address_id` <=> OLD.`address_id` ) THEN
			SET `changed_data` = JSON_INSERT(`changed_data`,'$.address_id', JSON_OBJECT('old', OLD.`address_id`, 'new', NEW.`address_id`));
		END IF;
        
        IF NOT (NEW.`customer_id` <=> OLD.`customer_id`) THEN
			SET `changed_data` = JSON_INSERT(`changed_data`,'$.customer_id', JSON_OBJECT('old', OLD.`customer_id`, 'new', NEW.`customer_id`));
        END IF;
		
        IF NOT (NEW.`status` <=> OLD.`status`) THEN
			SET `changed_data` = JSON_INSERT(`changed_data`,'$.status', JSON_OBJECT('old', OLD.`status`, 'new', NEW.`status`));
        END IF;
        
        -- Only log if there are changes
        IF JSON_LENGTH(`changed_data`) > 0 THEN
			INSERT INTO `log_order`(`order_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES
            (
				OLD.`id`,
                'UPDATE',
                'Order is updated',
                `changed_data`,
                USER()
            );
        END IF;
        
	END$$

    
-- Triggers on the table Customer
CREATE TRIGGER `trigger_log_update_customer`
	AFTER UPDATE ON `customer`
	FOR EACH ROW
	BEGIN
		DECLARE `changed_data` JSON;
        
        -- Build the JSON object with only the changed fields
		SET `changed_data` = JSON_OBJECT();
        
        -- Check each field for changes and add them to the JSON object
		IF NOT (NEW.`first_name` <=> OLD.`first_name`) THEN
			SET `changed_data` = JSON_INSERT(`changed_data`, '$.first_name', JSON_OBJECT('old', OLD.`first_name`, 'new', NEW.`first_name`));
		END IF;

		IF NOT (NEW.`last_name` <=> OLD.`last_name`) THEN
			SET `changed_data` = JSON_INSERT(`changed_data`, '$.last_name', JSON_OBJECT('old', OLD.`last_name`, 'new', NEW.`last_name`));
		END IF;

		IF NOT (NEW.`email` <=> OLD.`email`) THEN
			SET `changed_data` = JSON_INSERT(`changed_data`, '$.email', JSON_OBJECT('old', OLD.`email`, 'new', NEW.`email`));
		END IF;

		IF NOT (NEW.`mobile_number` <=> OLD.`mobile_number`) THEN
			SET `changed_data` = JSON_INSERT(`changed_data`, '$.mobile_number', JSON_OBJECT('old', OLD.`mobile_number`, 'new', NEW.`mobile_number`));
		END IF;
        
		-- Only log if there are changes
        IF JSON_LENGTH(changed_data) > 0 THEN
			INSERT INTO `log_customer`(`customer_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES
			(
			OLD.`id`,
			'UPDATE',
			'Customer info is updated',        
			`changed_data`,
            USER()
			);
		END IF;
        
	END$$


CREATE TRIGGER `trigger_log_insert_customer`
	AFTER INSERT ON `customer`
	FOR EACH ROW
	BEGIN
		
       	INSERT INTO `log_customer`(`customer_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES
		(
        NEW.`id`, 
        'INSERT', 
        'Customer is created',
        JSON_OBJECT(
			'id', NEW.`id`,
            'first_name', NEW.`first_name`,
            'last_name', NEW.`last_name`,
            'email', NEW.`email`,
            'mobile_number', NEW.`mobile_number`
            ),
		USER()
		);
        
	END$$
    

CREATE TRIGGER `trigger_log_delete_customer`
	BEFORE DELETE ON `customer`
	FOR EACH ROW
	BEGIN
    
       	INSERT INTO `log_customer`(`customer_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES
		(
        OLD.`id`, 
        'DELETE', 
        'Customer is deleted', 
        JSON_OBJECT(
			'id', OLD.`id`,
            'first_name', OLD.`first_name`,
            'last_name', OLD.`last_name`,
            'email', OLD.`email`,
            'mobile_number', OLD.`mobile_number`
            ),
		USER()
		);
        
	END$$
    
    
CREATE TRIGGER `trigger_log_insert_address`
	AFTER INSERT ON `address`
    FOR EACH ROW
    BEGIN
        
        INSERT INTO `log_address` (`address_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES
        (
			NEW.`id`,
            'INSERT',
            'New address is created',
            JSON_OBJECT(
				'id', NEW.`id`,
                'full_address', NEW.`full_address`,
                'locality', NEW.`locality`,
                'postal_code', NEW.`postal_code`,
                'state', NEW.`state`,
                'country', NEW.`country`
            ),
			USER()
        );
    
    END $$
    
    
CREATE TRIGGER `trigger_log_update_address`
	AFTER UPDATE ON `address`
    FOR EACH ROW
    BEGIN
		
        DECLARE `changed_data` JSON;
        
        -- Initialize the object
        SET `changed_data` = JSON_OBJECT();
        
        -- Check each field for changes
        IF NOT (NEW.`full_address` <=> OLD.`full_address`) THEN
			SET `changed_data` = JSON_INSERT(`changed_data`, '$.full_address', JSON_OBJECT('old', OLD.`full_address`, 'new', NEW.`full_address`));
        END IF;
        
        IF NOT (NEW.`locality` <=> OLD.`locality`) THEN
			SET `changed_data` = JSON_INSERT(`changed_data`, '$.locality', JSON_OBJECT('old', OLD.`locality`, 'new', NEW.`locality`));
        END IF;
        
        IF NOT (NEW.`postal_code` <=> OLD.`postal_code`) THEN
			SET `changed_data` = JSON_INSERT(`changed_data`, '$.postal_code', JSON_OBJECT('old', OLD.`postal_code`, 'new', NEW.`postal_code`));
        END IF;
        
        IF NOT (NEW.`state` <=> OLD.`state`) THEN
			SET `changed_data` = JSON_INSERT(`changed_data`, '$.state', JSON_OBJECT('old', OLD.`state`, 'new', NEW.`state`));
        END IF;
        
        IF NOT (NEW.`country` <=> OLD.`country`) THEN
			SET `changed_data` = JSON_INSERT(`changed_data`, '$.country', JSON_OBJECT('old', OLD.`country`, 'new', NEW.`country`));
        END IF;
        
        
        -- Only log if there are changes
        IF JSON_LENGTH(changed_data) > 0 THEN
			INSERT INTO `log_address` (`address_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES
				(
					NEW.`id`,
					'UPDATE',
					'Address is updated',
					`changed_data`,
                    USER()
				);
		END IF;
    
    END $$



CREATE TRIGGER `trigger_log_delete_address`
	BEFORE DELETE ON `address`
    FOR EACH ROW
    BEGIN
        
        INSERT INTO `log_address` (`address_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES
        (
			OLD.`id`,
            'DELETE',
            'Address is deleted',
            JSON_OBJECT(
				'id', OLD.`id`,
                'full_address', OLD.`full_address`,
                'locality', OLD.`locality`,
                'postal_code', OLD.`postal_code`,
                'state', OLD.`state`,
                'country', OLD.`country`
            ),
            USER()
        );
    
    END $$


CREATE TRIGGER `trigger_log_insert_cart`
AFTER INSERT ON `cart`
FOR EACH ROW
BEGIN

	INSERT INTO `log_cart`(`cart_id`, `order_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES (
		NEW.`id`,
        NEW.`order_id`,
        'INSERT',
        'A new product was added to a cart',
        JSON_OBJECT(
			'cart_id', NEW.`id`,
            'order_id', NEW.`order_id`,
            'product_id', NEW.`product_id`,
            'quantity', NEW.`quantity`,
            'unit_price', NEW.`unit_price`
        ),
        USER()
    );

END$$


CREATE TRIGGER `trigger_log_delete_cart`
BEFORE DELETE ON `cart`
FOR EACH ROW
BEGIN

	-- Log the trigger start
    INSERT INTO `log_trigger`(`trigger_name`, `action`, `description`) VALUES (
		'trigger_log_delete_cart',
        'START',
        'Trigger execution started'
    );

	-- Run the trigger itself
	INSERT INTO `log_cart`(`cart_id`, `order_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES (
		OLD.`id`,
        OLD.`order_id`,
        'DELETE',
        'A product was removed from a cart',
        JSON_OBJECT(
			'cart_id', OLD.`id`,
            'order_id', OLD.`order_id`,
            'product_id', OLD.`product_id`,
            'quantity', OLD.`quantity`,
            'unit_price', OLD.`unit_price`
        ),
        USER()
    );
    
    -- Log the end of the trigger
    INSERT INTO `log_trigger`(`trigger_name`, `action`, `description`) VALUES (
		'trigger_log_delete_cart',
        'END',
        'Trigger execution finished'
    );

END$$


CREATE TRIGGER `trigger_log_update_cart`
AFTER UPDATE ON `cart`
FOR EACH ROW
BEGIN

	DECLARE `changed_data` JSON;
    
    -- Initialize the JSON object
    SET `changed_data` = JSON_OBJECT();
    
    /* Check the evolution of each column and add it to the JSON object
    The only evolution possible is the change of quantity or price. Other evolutions (change of order, product) are not possible and are managed via removal of a cart record and creation of a new one */
    IF NOT (NEW.`quantity` <=> OLD.`quantity`) THEN
		SET `changed_data` = JSON_INSERT(`changed_data`, '$.quantity', JSON_OBJECT('old', OLD.`quantity`, 'new', NEW.`quantity`));
    END IF;
    
    IF NOT (NEW.`unit_price` <=> OLD.`unit_price`) THEN
		SET `changed_data` = JSON_INSERT(`changed_data`, '$.unit_price', JSON_OBJECT('old', OLD.`unit_price`, 'new', NEW.`unit_price`));
    END IF;
    
    -- Only log if there are changes
    IF JSON_LENGTH(`changed_data`) > 0 THEN
		INSERT INTO `log_cart`(`cart_id`, `order_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES (
		NEW.`id`,
        NEW.`order_id`,
        'UPDATE',
        'Product price or quanity have evolved within a cart',
        `changed_data`,
        USER()
		);
    END IF;

END$$


CREATE TRIGGER `trigger_log_insert_customer_address`
AFTER INSERT ON `customer_address`
FOR EACH ROW
BEGIN

	INSERT INTO `log_customer_address`(`customer_id`, `address_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES (
		NEW.`customer_id`,
        NEW.`address_id`,
        'INSERT',
        'New address is associated with a customer',
        JSON_OBJECT(
				'customer_address_id', NEW.`id`,
                'customer_id', NEW.`customer_id`,
                'address_id', NEW.`address_id`,
                'nickname', NEW.`nickname`
			),
		USER()
    );

END$$

CREATE TRIGGER `trigger_log_delete_customer_address`
BEFORE DELETE ON `customer_address`
FOR EACH ROW
BEGIN

	INSERT INTO `log_customer_address`(`customer_id`, `address_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES (
		OLD.`customer_id`,
        OLD.`address_id`,
        'DELETE',
        'An address is disassociated with a customer',
        JSON_OBJECT(
				'customer_address_id', OLD.`id`,
                'customer_id', OLD.`customer_id`,
                'address_id', OLD.`address_id`,
                'nickname', OLD.`nickname`
			),
		USER()
    );

END$$

CREATE TRIGGER `trigger_log_update_customer_address`
AFTER UPDATE ON `customer_address`
FOR EACH ROW
BEGIN
	
    DECLARE `changed_data` JSON;
    
    -- Initialize the JSON object
    SET `changed_data`= JSON_OBJECT();
    
    -- Check the evolution of each attribute and append it to the JSON object
    IF NOT (NEW.`nickname` <=> OLD.`nickname`) THEN
		SET `changed_data` = JSON_INSERT(`changed_data`, '$.nickname', JSON_OBJECT('old', OLD.`nickname`, 'new', NEW.`nickname`));
    END IF;

	-- Log only if the JSON if not empty
    IF JSON_LENGTH(`changed_data`) > 0 THEN
		INSERT INTO `log_customer_address`(`customer_id`, `address_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES (
		NEW.`customer_id`,
        NEW.`address_id`,
        'UPDATE',
        'An association of an address with a customer is updated',
        `changed_data`,
        USER()
    );
    END IF;
    
END$$

DELIMITER $$

CREATE TRIGGER `trigger_product_price_update`
AFTER UPDATE ON `product`
FOR EACH ROW
BEGIN

	-- Idea: When a product price evolves, then all orders in the status new should get price update
    
    -- Check either it was the price what have evolved
    IF NOT (NEW.`unit_price_USD` <=> OLD.`unit_price_USD`) THEN
        
        -- Update the product unit price in all orders having that product and being still in the -new- state
        UPDATE `cart`
        SET `unit_price` = NEW.`unit_price_USD`
        WHERE (`order_id` IN (SELECT `id` FROM `order` WHERE `status` = 'new')) AND `product_id` = NEW.`id`;
        
	END IF;
    
END$$


CREATE TRIGGER `trigger_log_insert_product`
AFTER INSERT ON `product`
FOR EACH ROW
BEGIN
	
    -- Log the product creationg
	INSERT INTO `log_product` (`product_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES (
			NEW.`id`,
            'INSERT',
            'New product was created',
            JSON_OBJECT(
					'name', NEW.`name`,
                    'description', NEW.`description`,
                    'unit_price_USD', NEW.`unit_price_USD`,
                    'out_of_stock', NEW.`out_of_stock`
                ),
            USER()
        );

END$$


CREATE TRIGGER `trigger_log_delete_product`
BEFORE DELETE ON `product`
FOR EACH ROW
BEGIN

	INSERT INTO `log_product` (`product_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES (
			OLD.`id`,
            'DELETE',
            'A product was deleted',
            JSON_OBJECT(
					'name', OLD.`name`,
                    'description', OLD.`description`,
                    'unit_price_USD', OLD.`unit_price_USD`,
                    'out_of_stock', OLD.`out_of_stock`
                ),
            USER()
        );
    
END$$


CREATE TRIGGER `trigger_log_update_product`
AFTER UPDATE ON `product`
FOR EACH ROW
BEGIN

	DECLARE `changed_data` JSON;
    
    -- Initialize the json object
    SET `changed_data` = JSON_OBJECT();
    
    -- Check every value that could have been changed and append the record to the JSON file
    IF NOT (NEW.`name` <=> OLD.`name`) THEN
		SET `changed_data` = JSON_INSERT(`changed_data`, '$.name', JSON_OBJECT('old', OLD.`name`, 'new', NEW.`name`)) ;
    END IF;
    
    IF NOT (NEW.`description` <=> OLD.`description`) THEN
		SET `changed_data` = JSON_INSERT(`changed_data`, '$.description', JSON_OBJECT('old', OLD.`description`, 'new', NEW.`description`)) ;
    END IF;
    
    IF NOT (NEW.`unit_price_USD` <=> OLD.`unit_price_USD`) THEN
		SET `changed_data` = JSON_INSERT(`changed_data`, '$.unit_price_USD', JSON_OBJECT('old', OLD.`unit_price_USD`, 'new', NEW.`unit_price_USD`)) ;
    END IF;
    
	IF NOT (NEW.`out_of_stock` <=> OLD.`out_of_stock`) THEN
		SET `changed_data` = JSON_INSERT(`changed_data`, '$.out_of_stock', JSON_OBJECT('old', OLD.`out_of_stock`, 'new', NEW.`out_of_stock`)) ;
    END IF;
    
    -- Log only if there were changes
    IF JSON_LENGTH(`changed_data`) > 0 THEN
    
		INSERT INTO `log_product` (`product_id`, `action`, `description`, `changed_data`, `changed_by`) VALUES (
			OLD.`id`,
            'UPDATE',
            'A product was updated',
            `changed_data`,
            USER()
        );
    END IF;

END$$



/* PROCEDURES */

/* The procedure will add a new product to an order (cart)
- to an existing order (if the order is still in a modifiable state) 
- if not, a new to a new order is created (if order is NOT in a state allowing the additing of new products)

The addition is denied if the product oready exists within the order, or such a customer doesn't exist */

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
        
			-- Check either the product is already within the cart
            IF `p_product_id` IN (SELECT `product_id` FROM `cart` WHERE `order_id` = `p_order_id`) THEN
            
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
				SET MESSAGE_TEXT = 'The product is not yet added to the cart. Please first add the product to the cart';
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


/*
This procedure :
- removes a product from a cart
*/

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
					DELETE FROM `cart`
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