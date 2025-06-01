CREATE DATABASE IF NOT EXISTS tech_retail CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tech_retail;

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    mfa_enabled BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    image_url VARCHAR(255),
    seller_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_status ENUM('pending','paid','shipped','delivered','cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method ENUM('payfast','ozow') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('pending','completed','failed') DEFAULT 'pending',
    transaction_ref VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE IF NOT EXISTS delivery_options (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS order_delivery (
    order_id INT PRIMARY KEY,
    delivery_id INT NOT NULL,
    tracking_number VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (delivery_id) REFERENCES delivery_options(delivery_id)
);

INSERT INTO delivery_options (name, price, description) VALUES
('PostNet', 99.00, '2-4 days, tracking included'),
('The Courier Guy', 120.00, '1-2 days, door-to-door'),
('PEP Paxi', 60.00, '3-5 days, pickup at PEP store'),
('FedEx', 250.00, 'Overnight, national/international');

INSERT INTO products (name, price, image_url, seller_id) VALUES
('iPad', 19000.00, 'images/ipad.jpeg', NULL),
('Iphone 13', 12500.00, 'images/iphone.jpeg', NULL),
('HP Laptop', 15800.00, 'images/hp-laptop.jpeg', NULL);

INSERT INTO users (email, password_hash, mfa_enabled) VALUES
('admin@techretail.com', '$12345', TRUE);

CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_orders_user ON orders(user_id);