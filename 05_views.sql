
USE ecommerce_db;

-- VIEW 1: USER ORDER DETAILS
CREATE VIEW user_order_view AS
SELECT
    u.full_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM users u
JOIN orders o
ON u.user_id = o.user_id;

-- DISPLAY VIEW 1
SELECT * FROM user_order_view;

-- VIEW 2: ORDER PRODUCT DETAILS
CREATE VIEW order_product_view AS
SELECT
    oi.order_id,
    p.product_name,
    oi.quantity,
    oi.price
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id;

-- DISPLAY VIEW 2
SELECT * FROM order_product_view;