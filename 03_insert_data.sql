
USE ecommerce_db;

-- INSERT 10 USERS
INSERT INTO users
(full_name,email,mobile_number,password)
VALUES
('Jyothika','jyothika@gmail.com','9876500001','pass123'),
('Rahul','rahul@gmail.com','9876500002','pass123'),
('Priya','priya@gmail.com','9876500003','pass123'),
('Sneha','sneha@gmail.com','9876500004','pass123'),
('Kiran','kiran@gmail.com','9876500005','pass123'),
('Anjali','anjali@gmail.com','9876500006','pass123'),
('Arjun','arjun@gmail.com','9876500007','pass123'),
('Divya','divya@gmail.com','9876500008','pass123'),
('Manoj','manoj@gmail.com','9876500009','pass123'),
('Sravani','sravani@gmail.com','9876500010','pass123');

-- INSERT 6 CATEGORIES
INSERT INTO categories(category_name,description)
VALUES
('Electronics','Electronic products'),
('Fashion','Clothing and accessories'),
('Books','Educational books'),
('Home','Home appliances'),
('Grocery','Daily needs'),
('Beauty','Beauty products');

-- INSERT 20 PRODUCTS
INSERT INTO products
(product_name,price,stock_quantity,category_id)
VALUES
('Laptop',55000,10,1),
('Mobile',20000,15,1),
('Headphones',1500,20,1),
('Smart Watch',3000,12,1),
('T Shirt',500,30,2),
('Jeans',1200,25,2),
('Shoes',2500,15,2),
('MBA Book',600,20,3),
('Java Book',450,25,3),
('SQL Book',500,18,3),
('Mixer',2500,10,4),
('Chair',1500,8,4),
('Rice Bag',1200,20,5),
('Oil',180,30,5),
('Face Wash',250,15,6),
('Sunscreen',400,10,6),
('Keyboard',800,0,1),
('Mouse',400,0,1),
('Bag',900,12,2),
('Water Bottle',300,20,4);

-- INSERT 12 ORDERS
INSERT INTO orders
(user_id,order_status,total_amount)
VALUES
(1,'PLACED',0),
(2,'SHIPPED',0),
(3,'PLACED',0),
(4,'SHIPPED',0),
(5,'PLACED',0),
(6,'PLACED',0),
(7,'SHIPPED',0),
(8,'PLACED',0),
(9,'SHIPPED',0),
(10,'PLACED',0),
(1,'PLACED',0),
(2,'SHIPPED',0);

-- INSERT 24 ORDER ITEMS
INSERT INTO order_items
(order_id,product_id,quantity,price)
VALUES
(1,2,1,20000),
(1,3,1,1500),
(2,1,1,55000),
(2,9,1,450),
(3,4,1,3000),
(3,5,1,500),
(4,6,1,1200),
(4,8,1,600),
(5,11,1,2500),
(5,12,1,1500),
(6,8,1,600),
(6,10,1,500),
(7,7,1,2500),
(7,6,1,1200),
(8,13,1,1200),
(8,14,1,180),
(9,3,1,1500),
(9,20,1,300),
(10,16,1,400),
(10,15,1,250),
(11,5,1,500),
(11,18,1,400),
(12,19,1,900),
(12,14,1,180);

-- UPDATE TOTAL ORDER AMOUNTS
UPDATE orders o
SET total_amount = (
    SELECT COALESCE(SUM(oi.quantity * oi.price),0)
    FROM order_items oi
    WHERE oi.order_id = o.order_id
);

-- INSERT 12 PAYMENTS
INSERT INTO payments
(order_id,payment_method,payment_status)
VALUES
(1,'UPI','SUCCESS'),
(2,'CARD','SUCCESS'),
(3,'UPI','SUCCESS'),
(4,'COD','PENDING'),
(5,'CARD','SUCCESS'),
(6,'UPI','SUCCESS'),
(7,'COD','PENDING'),
(8,'UPI','SUCCESS'),
(9,'CARD','SUCCESS'),
(10,'UPI','SUCCESS'),
(11,'COD','PENDING'),
(12,'CARD','SUCCESS');

-- VERIFY DATA
SELECT * FROM users;
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM payments;