    -- Check either the Customer exists
    IF `p_customer_id` IN (SELECT `id` FROM `customer`) THEN
    
		-- Check either a valid order exists
		IF 	`var_order` IS NOT NULL THEN
			
            -- A vadid order exists. Now let's check either the desired product already doesn't exist yet within the cart
            IF `p_product_id` != (SELECT `product_id` FROM `product_order` WHERE `order_id` = `var_order`) THEN
            
                -- Let's conduct the addition of a product to the cart
                INSERT INTO `product_order` (`order_id`, `product_id`, `quantity`, `unit_price`) VALUES
                (`var_order`, `p_product_id`, `p_quantity`, `var_unit_price`);
            ELSE
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

            -- Add the product to that newly created order
            INSERT INTO `product_order` (`order_id`, `product_id`, `quantity`, `unit_price`) VALUES
            (`var_order`, `p_product_id`, `p_quantity`, `var_unit_price`);

		END IF;
    
    -- The Customer doesn't exist. We exit the procedure with an error message
    ELSE
		SIGNAL SQLSTATE '45004' -- Custom error code
		SET MESSAGE_TEXT = 'Such Customer does NOT exist';	
    END IF;
END$$