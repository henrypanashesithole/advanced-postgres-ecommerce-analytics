-- =========================================================================
-- ADVANCED E-COMMERCE ANALYTICS DATABASE DDL & DML ARCHITECTURE
-- Author: Henry Panashe Sithole
-- Engine: PostgreSQL
-- =========================================================================

-- 1. SCHEMA DESIGN (TABLE CREATION)
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50),
    join_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    cost_price NUMERIC(10, 2) NOT NULL,
    selling_price NUMERIC(10, 2) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date TIMESTAMP NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    shipping_city VARCHAR(50) NOT NULL
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id) ON DELETE RESTRICT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL
);

-- 2. DATA POPULATION (DML)
INSERT INTO products (product_name, category, cost_price, selling_price) VALUES
('Wireless Mouse', 'Electronics', 10.00, 25.00), ('Mechanical Keyboard', 'Electronics', 35.00, 75.00),
('Gaming Headset', 'Electronics', 20.00, 45.00), ('Ergonomic Office Chair', 'Furniture', 80.00, 180.00),
('Standing Desk', 'Furniture', 120.00, 299.00), ('Stainless Steel Water Bottle', 'Kitchen', 5.00, 18.00),
('Ceramic Coffee Mug', 'Kitchen', 2.50, 12.00), ('Cotton T-Shirt', 'Apparel', 4.00, 15.00),
('Running Shoes', 'Apparel', 30.00, 85.00), ('Leather Wallet', 'Apparel', 12.00, 40.00);

INSERT INTO customers (first_name, last_name, email, city, join_date) VALUES
('Tendai', 'Moyo', 'tendai.moyo@email.com', 'Harare', '2025-01-15'),
('Chipo', 'Sibanda', 'chipo.s@email.com', 'Bulawayo', '2025-02-10'),
('John', 'Doe', 'john.doe@email.com', 'Mutare', '2025-03-01'),
('Sarah', 'Jenkins', 'sarah.j@email.com', 'Harare', '2025-04-18'),
('Farai', 'Ndlovu', 'farai.n@email.com', 'Gweru', '2025-05-12'),
('Grace', 'Mugabe', 'grace.m@email.com', 'Harare', '2025-06-01'),
('Michael', 'Smith', 'm.smith@email.com', 'Masvingo', '2025-06-20');

INSERT INTO orders (customer_id, order_date, payment_method, shipping_city) VALUES
(1, '2026-01-10 10:30:00', 'EcoCash', 'Harare'), (2, '2026-01-15 14:20:00', 'Visa', 'Bulawayo'),
(3, '2026-02-01 09:15:00', 'Mastercard', 'Mutare'), (1, '2026-02-20 16:45:00', 'EcoCash', 'Harare'),
(4, '2026-03-05 11:00:00', 'Visa', 'Harare'), (5, '2026-03-12 13:10:00', 'OneMoney', 'Gweru'),
(2, '2026-04-02 15:30:00', 'Visa', 'Bulawayo'), (6, '2026-04-22 08:25:00', 'EcoCash', 'Harare'),
(7, '2026-05-01 17:05:00', 'Cash', 'Masvingo'), (3, '2026-05-18 12:40:00', 'Mastercard', 'Mutare');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 25.00), (1, 2, 1, 75.00), (2, 4, 1, 180.00), (3, 6, 2, 18.00), (3, 7, 1, 12.00),
(4, 3, 1, 45.00), (5, 5, 1, 299.00), (5, 4, 1, 180.00), (6, 8, 3, 15.00), (7, 9, 1, 85.00),
(7, 10, 1, 40.00), (8, 5, 1, 299.00), (9, 8, 2, 15.00), (9, 6, 1, 18.00), (10, 2, 1, 75.00);

-- 3. ADVANCED ANALYTICS & OPTIMIZATION OPERATIONS
-- Multi-Table Revenue Join
SELECT o.order_id, c.first_name, c.last_name, p.product_name, oi.quantity, oi.unit_price, (oi.quantity * oi.unit_price) AS total_item_revenue
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON oi.product_id = p.product_id;

-- Customer Lifetime Value (LTV) Aggregation
SELECT c.customer_id, c.first_name, c.last_name, COUNT(DISTINCT o.order_id) AS total_orders_placed, SUM(oi.quantity * oi.unit_price) AS lifetime_value
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY lifetime_value DESC;

-- Customer Behavior Analytics Using CTEs
WITH city_sales_summary AS (
    SELECT o.shipping_city, SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.shipping_city
)
SELECT shipping_city, total_sales FROM city_sales_summary WHERE total_sales > 300.00;

-- Cumulative Running Total Using Window Functions
SELECT o.order_id, o.order_date, SUM(oi.quantity * oi.unit_price) AS order_total,
       SUM(SUM(oi.quantity * oi.unit_price)) OVER (ORDER BY o.order_date) AS running_total
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date
ORDER BY o.order_date;

-- B-Tree Performance Optimization
CREATE INDEX idx_orders_order_date ON orders(order_date);

-- Data Quality Control
ALTER TABLE orders ADD CONSTRAINT chk_payment_method CHECK (payment_method IN ('EcoCash', 'Visa', 'Mastercard', 'OneMoney', 'Cash'));


