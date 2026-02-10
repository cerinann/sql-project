# Online Bookstore - SQL Order Management System

## Overview

This project implements a simple Order Management System for an online bookstore using PostgreSQL.

The system manages readers, books, purchases, and purchase details. It demonstrates how relational databases handle entity relationships, transactional data, and pricing changes while maintaining data integrity.

The goal of this project is to practice practical SQL concepts using a structured business scenario.

---

## Business Problem

An online bookstore needs a system to:

- Manage registered readers
- Maintain a catalog of books
- Track customer purchases
- Store individual books purchased in each order
- Update book prices over time
- Maintain historical purchase records

---

## Database Structure

**Database Name:** `book_store_db`  
**Schema:** `bookstore`

---

## Tables Created

### 1. readers
Stores customer information:

- `reader_id` (Primary Key)
- `reader_name`
- `email_address` (Unique)
- `contact_number`
- `registered_on` (Default timestamp)

---

### 2. books
Stores book catalog details:

- `book_id` (Primary Key)
- `title`
- `genre`
- `current_price`
- `available` (Boolean flag)

---

### 3. purchases
Stores order-level details:

- `purchase_id` (Primary Key)
- `reader_id` (Foreign Key → readers)
- `purchase_date`
- `total_cost`
- `order_status`

---

### 4. purchase_items
Stores individual books inside each purchase:

- `purchase_item_id` (Primary Key)
- `purchase_id` (Foreign Key → purchases)
- `book_id` (Foreign Key → books)
- `quantity` (CHECK constraint > 0)
- `purchase_price` (Price at time of purchase)

---

## Key Concepts Covered

### Data Definition Language (DDL)

- Creating databases and schemas
- Creating tables with primary and foreign keys
- Using CHECK constraints
- Defining default values
- Enforcing uniqueness

### Data Manipulation Language (DML)

- Inserting sample data
- Updating book prices
- Deleting records
- Retrieving data using JOIN queries

---

## PostgreSQL Features Used

- `SERIAL` (Auto-increment primary keys)
- `FOREIGN KEY` constraints
- `CHECK` constraints
- `DEFAULT` values (timestamps & status)
- `NUMERIC` data type for financial accuracy
- Schema usage for logical organization
