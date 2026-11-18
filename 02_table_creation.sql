
-- SELECT DATABASE
USE ecommerce_db;

-- 1. USERS TABLE
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mobile_number VARCHAR(15) UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. CATEGORIES TABLE
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    description VARCHAR(255)
) ENGINE=InnoDB;

-- 3. PRODUCTS TABLE
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK(price >= 0),
    stock_quantity INT NOT NULL CHECK(stock_quantity >= 0),
    category_id INT NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(category_id)
    REFERENCES categories(category_id)
) ENGINE=InnoDB;

-- 4. ORDERS TABLE
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_status ENUM('PLACED','SHIPPED','CANCELLED')
    DEFAULT 'PLACED',
    total_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY(user_id)
    REFERENCES users(user_id)
) ENGINE=InnoDB;

-- 5. ORDER ITEMS TABLE
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK(quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK(price >= 0),
    FOREIGN KEY(order_id)
    REFERENCES orders(order_id),
    FOREIGN KEY(product_id)
    REFERENCES products(product_id)
) ENGINE=InnoDB;

-- 6. PAYMENTS TABLE
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT UNIQUE NOT NULL,
    payment_method ENUM('UPI','CARD','COD'),
    payment_status ENUM('SUCCESS','FAILED','PENDING'),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(order_id)
    REFERENCES orders(order_id)
) ENGINE=InnoDB;

-- CHECK TABLES
SHOW TABLES;