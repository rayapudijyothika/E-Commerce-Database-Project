
USE ecommerce_db;

-- TRANSACTION EXAMPLE

START TRANSACTION;

-- STEP 1: CREATE NEW ORDER
INSERT INTO orders
(user_id,order_status,total_amount)
VALUES
(3,'PLACED',0);

-- STORE NEW ORDER ID
SET @new_order_id = LAST_INSERT_ID();

-- STEP 2: INSERT ORDER ITEM
INSERT INTO order_items
(order_id,product_id,quantity,price)
SELECT
    @new_order_id,
    product_id,
    1,
    price
FROM products
WHERE product_id = 1;

-- STEP 3: UPDATE TOTAL AMOUNT
UPDATE orders
SET total_amount = (
    SELECT COALESCE(SUM(quantity * price),0)
    FROM order_items
    WHERE order_id = @new_order_id
)
WHERE order_id = @new_order_id;

-- STEP 4: COMMIT TRANSACTION
COMMIT;

-- VERIFY RESULT
SELECT * FROM orders
WHERE order_id = @new_order_id;

-- ROLLBACK EXAMPLE
START TRANSACTION;

UPDATE products
SET stock_quantity = stock_quantity - 1
WHERE product_id = 1;

-- CANCEL THE ABOVE CHANGE
ROLLBACK;

-- VERIFY STOCK
SELECT * FROM products
WHERE product_id = 1;