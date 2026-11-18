
USE ecommerce_db;

-- CREATE ORDER STATUS LOG TABLE
CREATE TABLE order_status_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(order_id)
    REFERENCES orders(order_id)
);

DELIMITER //

-- TRIGGER 1: CHECK STOCK BEFORE INSERT
CREATE TRIGGER check_stock_before_order
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE v_stock INT DEFAULT NULL;

    SELECT stock_quantity
    INTO v_stock
    FROM products
    WHERE product_id = NEW.product_id;

    IF v_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product does not exist';
    ELSEIF v_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient product stock';
    END IF;
END //

-- TRIGGER 2: REDUCE STOCK AFTER INSERT
CREATE TRIGGER reduce_stock_after_order
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END //

-- TRIGGER 3: LOG ORDER STATUS CHANGES
CREATE TRIGGER log_order_status
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.order_status <> NEW.order_status THEN

        INSERT INTO order_status_log
        (order_id,old_status,new_status)
        VALUES
        (OLD.order_id,OLD.order_status,NEW.order_status);

    END IF;
END //

DELIMITER ;

-- TEST STOCK TRIGGER
-- Example: Insert an order item with sufficient stock.
-- Use a new order ID when testing.
-- INSERT INTO order_items
-- (order_id,product_id,quantity,price)
-- VALUES (1,1,1,55000);

-- TEST STATUS TRIGGER
UPDATE orders
SET order_status = 'SHIPPED'
WHERE order_id = 1;

-- CHECK STATUS LOG
SELECT * FROM order_status_log;