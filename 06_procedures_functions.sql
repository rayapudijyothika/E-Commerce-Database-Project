
USE ecommerce_db;

DELIMITER //

-- PROCEDURE 1: ADD NEW PRODUCT
CREATE PROCEDURE add_product(
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10,2),
    IN p_stock INT,
    IN p_category INT
)
BEGIN
    INSERT INTO products
    (product_name,price,stock_quantity,category_id)
    VALUES
    (p_name,p_price,p_stock,p_category);
END //

-- PROCEDURE 2: PLACE NEW ORDER
CREATE PROCEDURE place_new_order(
    IN p_user_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_order_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;

    SELECT price INTO v_price
    FROM products
    WHERE product_id = p_product_id;

    IF v_price IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product not found';
    END IF;

    INSERT INTO orders
    (user_id,order_status,total_amount)
    VALUES
    (p_user_id,'PLACED',0);

    SET v_order_id = LAST_INSERT_ID();

    INSERT INTO order_items
    (order_id,product_id,quantity,price)
    VALUES
    (v_order_id,p_product_id,p_quantity,v_price);

    UPDATE orders
    SET total_amount = v_price * p_quantity
    WHERE order_id = v_order_id;

    COMMIT;
END //

-- FUNCTION 1: CALCULATE ORDER TOTAL
CREATE FUNCTION calculate_order_total(
    p_order_id INT
)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);

    SELECT COALESCE(SUM(quantity * price),0)
    INTO v_total
    FROM order_items
    WHERE order_id = p_order_id;

    RETURN v_total;
END //

-- FUNCTION 2: CHECK PRODUCT STOCK
CREATE FUNCTION check_product_stock(
    p_product_id INT
)
RETURNS VARCHAR(30)
READS SQL DATA
BEGIN
    DECLARE v_stock INT DEFAULT NULL;

    SELECT stock_quantity INTO v_stock
    FROM products
    WHERE product_id = p_product_id;

    IF v_stock IS NULL THEN
        RETURN 'PRODUCT NOT FOUND';
    ELSEIF v_stock > 0 THEN
        RETURN 'AVAILABLE';
    ELSE
        RETURN 'OUT OF STOCK';
    END IF;
END //

DELIMITER ;

-- TEST PROCEDURE 1
CALL add_product('Tablet',15000,10,1);

-- TEST FUNCTION 1
SELECT calculate_order_total(1);

-- TEST FUNCTION 2
SELECT check_product_stock(1);

-- TEST PROCEDURE 2
-- Uncomment to place a test order:
-- CALL place_new_order(1,2,2);