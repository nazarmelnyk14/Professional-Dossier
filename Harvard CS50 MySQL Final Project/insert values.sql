INSERT INTO `product` (`name`, `description`, `unit_price_USD`) VALUES
('Laptop', 'High-performance laptop with 16GB RAM and 512GB SSD', 999.99),
('Smartphone', 'Latest model smartphone with 5G connectivity', 699.50),
('Headphones', 'Wireless noise-canceling headphones', 199.99),
('Gaming Console', 'Next-gen gaming console with 1TB storage', 499.99),
('Smartwatch', 'Waterproof smartwatch with fitness tracking', 149.99),
('Tablet', 'Lightweight tablet with 10-inch display', 249.99),
('Camera', 'High-resolution DSLR camera', 799.00),
('Printer', 'Compact wireless printer', 129.99),
('Monitor', '27-inch 4K monitor', 349.99),
('Keyboard', 'Mechanical keyboard with RGB lighting', 79.99),
('Product 100', 'Generic description for product 100', 1000.00);


INSERT INTO `customer` (`first_name`, `last_name`, `email`, `mobile_number`) VALUES
('Alice', 'Smith', 'alice.smith1@example.com', '123-456-0001'),
('Bob', 'Johnson', 'bob.johnson2@example.com', '123-456-0002'),
('Charlie', 'Brown', 'charlie.brown3@example.com', '123-456-0003'),
('Dana', 'White', 'dana.white4@example.com', '123-456-0004'),
('Eve', 'Black', 'eve.black5@example.com', '123-456-0005'),
('Frank', 'Miller', 'frank.miller6@example.com', '123-456-0006'),
('Grace', 'Hopper', 'grace.hopper7@example.com', '123-456-0007'),
('Hank', 'Green', 'hank.green8@example.com', '123-456-0008'),
('Ivy', 'Adams', 'ivy.adams9@example.com', '123-456-0009'),
('Jack', 'Taylor', 'jack.taylor10@example.com', '123-456-0010'),
('Customer100', 'Lastname100', 'customer100@example.com', '123-456-0100');


INSERT INTO `address` (`full_address`, `locality`, `postal_code`, `state`, `country`) VALUES
('123 Main St', 'Springfield', '12345', 'IL', 'USA'),
('456 Elm St', 'Centerville', '67890', 'TX', 'USA'),
('789 Oak St', 'River City', '11223', 'CA', 'USA'),
('101 Pine St', 'Lakeview', '33445', 'FL', 'USA'),
('202 Maple St', 'Mountainview', '55667', 'CO', 'USA'),
('303 Birch St', 'Valleyview', '77889', 'NY', 'USA'),
('404 Cedar St', 'Hilltop', '99001', 'WA', 'USA'),
('505 Willow St', 'Clifftop', '22334', 'PA', 'USA'),
('606 Poplar St', 'Seaside', '44556', 'MA', 'USA'),
('707 Aspen St', 'Greensboro', '66778', 'NC', 'USA'),
('100 Main St', 'Lastville', '99887', 'MT', 'USA');


INSERT INTO `order` (`customer_id`, `address_id`, `status`) VALUES
(1, 1, 'new'),
(2, 2, 'payed'),
(3, 3, 'shipped'),
(4, 4, 'new'),
(5, 5, 'payed'),
(6, 6, 'shipped'),
(7, 7, 'new'),
(8, 8, 'payed'),
(9, 9, 'shipped'),
(10, 10, 'new'),
(11, 11, 'payed');


INSERT INTO `product_order` (`order_id`, `product_id`, `quantity`, `unit_price`) VALUES
-- Order 1: Contains 2 products
(1, 1, 2),  -- Product 1 with quantity 2
(1, 2, 1),  -- Product 2 with quantity 1

-- Order 2: Contains 1 product
(2, 3, 3),  -- Product 3 with quantity 3

-- Order 3: Contains 3 products
(3, 4, 1),  -- Product 4 with quantity 1
(3, 5, 2),  -- Product 5 with quantity 2
(3, 6, 1),  -- Product 6 with quantity 1

-- Order 4: Contains 1 product
(4, 7, 4),  -- Product 7 with quantity 4

-- Order 5: Contains 2 products
(5, 8, 2),  -- Product 8 with quantity 2
(5, 9, 3),  -- Product 9 with quantity 3

-- Order 6: Contains 1 product
(6, 10, 1), -- Product 10 with quantity 1

-- Order 7: Contains 1 product
(7, 1, 5),  -- Product 1 with quantity 5

-- Order 8: Contains 2 products
(8, 2, 1),  -- Product 2 with quantity 1
(8, 3, 2),  -- Product 3 with quantity 2

-- Order 9: Contains 1 product
(9, 4, 3),  -- Product 4 with quantity 3

-- Order 10: Contains 2 products
(10, 5, 4), -- Product 5 with quantity 4
(10, 6, 1), -- Product 6 with quantity 1

-- Order 11: Contains 1 product
(11, 7, 2); -- Product 7 with quantity 2

INSERT INTO `cart` (`order_id`, `product_id`, `quantity`, `unit_price`) VALUES
-- Order 1: Contains 2 products
(1, 1, 2, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 1)),  -- Product 1 with quantity 2
(1, 2, 1, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 2)),  -- Product 2 with quantity 1

-- Order 2: Contains 1 product
(2, 3, 3, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 3)),  -- Product 3 with quantity 3

-- Order 3: Contains 3 products
(3, 4, 1, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 4)),  -- Product 4 with quantity 1
(3, 5, 2, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 5)),  -- Product 5 with quantity 2
(3, 6, 1, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 6)),  -- Product 6 with quantity 1

-- Order 4: Contains 1 product
(4, 7, 4, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 7)),  -- Product 7 with quantity 4

-- Order 5: Contains 2 products
(5, 8, 2, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 8)),  -- Product 8 with quantity 2
(5, 9, 3, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 9)),  -- Product 9 with quantity 3

-- Order 6: Contains 1 product
(6, 10, 1, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 10)), -- Product 10 with quantity 1

-- Order 7: Contains 1 product
(7, 1, 5, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 1)),  -- Product 1 with quantity 5

-- Order 8: Contains 2 products
(8, 2, 1, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 2)),  -- Product 2 with quantity 1
(8, 3, 2, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 3)),  -- Product 3 with quantity 2

-- Order 9: Contains 1 product
(9, 4, 3, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 4)),  -- Product 4 with quantity 3

-- Order 10: Contains 2 products
(10, 5, 4, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 5)), -- Product 5 with quantity 4
(10, 6, 1, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 6)), -- Product 6 with quantity 1

-- Order 11: Contains 1 product
(11, 7, 2, (SELECT `unit_price_USD` FROM `product` WHERE `id` = 7)); -- Product 7 with quantity 2


