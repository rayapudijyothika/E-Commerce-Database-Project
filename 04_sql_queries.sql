
USE ecommerce_db;

-- 1. DISPLAY PRODUCTS WITH CATEGORY NAMES
SELECT
    p.product_id,
    p.product_name,
    p.price,
    c.category_name
FROM products p
INNER JOIN categories c
ON p.category_id = c.category_id;

-- 2. DISPLAY ORDERS BY SPECIFIC USER
SELECT *
FROM orders
WHERE user_id = 1;

-- 3. DISPLAY OUT OF STOCK PRODUCTS
SELECT *
FROM products
WHERE stock_quantity = 0;

-- 4. TOTAL ORDERS BY EACH USER
SELECT
    u.full_name,
    COUNT(o.order_id) AS total_orders
FROM users u
LEFT JOIN orders o
ON u.user_id = o.user_id
GROUP BY u.user_id,u.full_name;

-- 5. ORDER DETAILS WITH PRODUCT NAME
SELECT
    oi.order_id,
    p.product_name,
    oi.quantity,
    oi.price
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id;

-- 6. USERS WHO PLACED MORE THAN 2 ORDERS
SELECT
    u.user_id,
    u.full_name,
    COUNT(o.order_id) AS total_orders
FROM users u
JOIN orders o
ON u.user_id = o.user_id
GROUP BY u.user_id,u.full_name
HAVING COUNT(o.order_id) > 2;

-- 7. HIGHEST PRICED PRODUCT IN EACH CATEGORY
SELECT
    c.category_name,
    p.product_name,
    p.price
FROM products p
JOIN categories c
ON p.category_id = c.category_id
WHERE p.price = (
    SELECT MAX(p2.price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);

-- EXTRA SUBQUERY
SELECT *
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);