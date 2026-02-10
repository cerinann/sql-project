-- ======================================
-- Business Problem:
-- An online bookstore wants to build a simple order management system
-- to manage readers, books, purchases, and purchase details.
-- ======================================

-- Step 1: Create database
CREATE DATABASE book_store_db;

-- Step 2: Connect to database
-- (Use \c book_store_db in PostgreSQL)

-- Step 3: Create schema
CREATE SCHEMA bookstore;

-- Step 4: Create 'readers' table
CREATE TABLE bookstore.readers (
    reader_id SERIAL PRIMARY KEY,
    reader_name VARCHAR(100) NOT NULL,
    email_address VARCHAR(100) UNIQUE NOT NULL,
    contact_number VARCHAR(15),
    registered_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 5: Create 'books' table
CREATE TABLE bookstore.books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    genre VARCHAR(50),
    current_price NUMERIC(10,2) NOT NULL,
    available BOOLEAN DEFAULT TRUE
);

-- Step 6: Create 'purchases' table
CREATE TABLE bookstore.purchases (
    purchase_id SERIAL PRIMARY KEY,
    reader_id INT REFERENCES bookstore.readers(reader_id),
    purchase_date DATE DEFAULT CURRENT_DATE,
    total_cost NUMERIC(10,2),
    order_status VARCHAR(20) DEFAULT 'Processing'
);

-- Step 7: Create 'purchase_items' table
CREATE TABLE bookstore.purchase_items (
    purchase_item_id SERIAL PRIMARY KEY,
    purchase_id INT REFERENCES bookstore.purchases(purchase_id),
    book_id INT REFERENCES bookstore.books(book_id),
    quantity INT CHECK (quantity > 0),
    purchase_price NUMERIC(10,2) NOT NULL
);

-- Step 8: Insert data into readers
INSERT INTO bookstore.readers (reader_name, email_address, contact_number)
VALUES 
('Aditi Sharma', 'aditi@example.com', '9876543210'),
('Rohan Mehta', 'rohan@example.com', '9123456789'),
('Priya Verma', 'priya@example.com', '9988776655'),
('Karan Patel', 'karan@example.com', '8877665544'),
('Neha Joshi', 'neha@example.com', '9765432101'),
('Siddharth Roy', 'siddharth@example.com', '9654321870'),
('Tanvi Desai', 'tanvi@example.com', '9543218765'),
('Vikram Singh', 'vikram@example.com', '9432109876'),
('Meera Iyer', 'meera@example.com', '9321098765'),
('Aman Khan', 'aman@example.com', '9210987654');

-- Step 9: Insert data into books
INSERT INTO bookstore.books (title, genre, current_price)
VALUES 
('The Data Architect', 'Technology', 499.99),
('SQL Mastery', 'Technology', 199.99),
('Clean Code Practices', 'Programming', 149.99),
('Financial Analytics 101', 'Finance', 299.99),
('Designing Data Systems', 'Technology', 249.99);

-- Step 10: Insert purchases
INSERT INTO bookstore.purchases (reader_id, total_cost, order_status) VALUES 
(1, 699.98, 'Completed'),
(3, 499.99, 'Shipped'),
(4, 449.98, 'Processing'),
(5, 149.99, 'Delivered'),
(7, 549.98, 'Completed');

-- Step 11: Insert purchase items
INSERT INTO bookstore.purchase_items (purchase_id, book_id, quantity, purchase_price) VALUES 
(1, 1, 1, 499.99),
(1, 2, 1, 199.99),
(2, 1, 1, 499.99),
(3, 4, 1, 299.99),
(3, 5, 1, 149.99),
(4, 3, 1, 149.99),
(5, 1, 1, 499.99),
(5, 2, 1, 50.00);

-- Step 12: Check reader purchases
SELECT r.reader_name, p.purchase_id, p.total_cost, p.order_status, p.purchase_date
FROM bookstore.readers r
JOIN bookstore.purchases p 
ON r.reader_id = p.reader_id;

-- Step 13: Update book price
UPDATE bookstore.books 
SET current_price = 179.99 
WHERE book_id = 2;

-- Step 14: Delete a reader (demo)
DELETE FROM bookstore.readers 
WHERE reader_id = 2;
