# E-commerce Transaction Database

A production-style PostgreSQL database project for learning relational
database design, SQL, transactions, constraints, normalization, indexing,
query optimization, and data integrity.

## Purpose

The system models the operational database of a small e-commerce busniness.

## Main Entities

- Customers
- Addresses
- Products
- Categories
- Orders
- Order Items
- Payments

## Learning Goals

- Relational database design
- Primary and foreign keys
- One-to-many and many-to-many relationships
- Normalization
- Transactions and ACID
- SQL
- Indexing 
- Query optimization
- Database testing


* PostgreSQL

* SQL

* Git and GitHub

* Linux terminal

* psql

* Version(PostgreSQL 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0, 64-bit)


# Create a fresh database
createdb ecommerce

# Build the initial schema
psql -v ON_ERROR_STOP=1 \
    -d ecommerce \
    -f sql/001_initial_schema.sql

# Create indexes
psql -v ON_ERROR_STOP=1 \
    -d ecommerce \
    -f sql/002_indexes.sql

# Apply the migration
psql -v ON_ERROR_STOP=1 \
    -d ecommerce \
    -f sql/migrations/001_add_cancellation_recorded_at.sql

