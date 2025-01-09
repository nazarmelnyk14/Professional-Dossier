DROP TRIGGER IF EXISTS `trigger_log_insert_order`;
DROP TRIGGER IF EXISTS `trigger_log_update_order`;

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
-- DROP TABLE IF EXISTS `order`; 
-- DROP TABLE IF EXISTS `product`; 
-- DROP TABLE IF EXISTS `customer`; 
-- DROP TABLE IF EXISTS `address`;



DROP TABLE IF EXISTS
	`cart`,
    `log_order`,
    `log_cart`,
    `order`, 
    `product`, 
    `customer`, 
    `address`,
    `log_procedure` -- to remove from this list before submission   
;

DROP TABLE IF EXISTS `log_procedures`;