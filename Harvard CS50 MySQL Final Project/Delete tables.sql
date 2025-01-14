DROP TRIGGER IF EXISTS `trigger_log_insert_order`;
DROP TRIGGER IF EXISTS `trigger_log_update_order`;

DROP TRIGGER IF EXISTS `trigger_log_insert_customer`;
DROP TRIGGER IF EXISTS `trigger_log_update_customer`;
DROP TRIGGER IF EXISTS `trigger_log_delete_customer`;

DROP TRIGGER IF EXISTS `trigger_log_insert_address`;
DROP TRIGGER IF EXISTS `trigger_log_update_address`;
DROP TRIGGER IF EXISTS `trigger_log_delete_address`;

DROP TRIGGER IF EXISTS `trigger_log_insert_cart`;
DROP TRIGGER IF EXISTS `trigger_log_update_cart`;
DROP TRIGGER IF EXISTS `trigger_log_delete_cart`;

DROP TRIGGER IF EXISTS `trigger_log_insert_customer_address`;
DROP TRIGGER IF EXISTS `trigger_log_update_customer_address`;
DROP TRIGGER IF EXISTS `trigger_log_delete_customer_address`;


DROP PROCEDURE IF EXISTS `add_product_to_cart`;
DROP PROCEDURE IF EXISTS `modify_product_quantity_at_cart`;
DROP PROCEDURE IF EXISTS `remove_product_from_cart`;

DROP VIEW IF EXISTS
	`product_line_price`, 
    `stats_by_order`, 
    `stats_by_product`
;


-- DROP TABLE IF EXISTS `product_order`;
-- DROP TABLE IF EXISTS `log_order`;
-- DROP TABLE IF EXISTS `log_cart`;
-- DROP TABLE IF EXISTS `order`; 
-- DROP TABLE IF EXISTS `product`; 
-- DROP TABLE IF EXISTS `customer`; 
-- DROP TABLE IF EXISTS `address`;
-- DROP TABLE IF EXISTS `log_address`;
-- DROP TABLE IF EXISTS `log_customer_json`;



DROP TABLE IF EXISTS
	`cart`,
	`log_address`,
    `log_order`,
    `log_cart`,
    `log_customer`,
    `order`, 
    `product`, 
    `customer`, 
    `address`,
    `customer_address`,
    `log_customer_address`,
    `log_procedure` -- to remove from this list before submission   
;

-- DROP TABLE IF EXISTS `log_procedures`;