# Project 01 - E-commerce Transaction Database

## 1. Problem Statement

A small e-commerce business needs a reliable operational database for storing
and managing information anout customers, addresses, products, categories,
orders, order items, and payments.

The database must preserve relationship between business entities, protect
data integrity, and support the basic operations required by an e-commerce
application. 

The primary goal of this project is to design and implement a relational
PostgreSQL database that correctly represents the business domain and 
provides a strong foundation for the future data engineering work.

---

## 2. Project Goals

The project should provide:

* A correctly designed relational database.
* Clear relationships between business entities.
* Strong data integritty through appropriate keys and constraints.
* Support for transactional operations.
* A maintainable and understandable schema.
* A foundation that can later act as an OLTP source for data engineering
pipelines.

---

## 3. Scope

### 3.1 In Scope

The first version of the system will contain:

* Customers
* Customer addresses
* Products
* Product categories
* Orders
* Order items
* Payments

The project will also cover:

* Primary keys
* Foreign keys
* Composite keys
* One-to-one / one-to-many / many-to-many relationships where appropriate
* Normalization
* Constraints
* Transaction
* Basic indexing
* Query analysis and optimization
* SQL queries for operational use and analysis

### 3.2 Out of Scope

The first version will not implement:

* Authentication
* Authorization for application users
* Product inventory management
* Shipping management
* Discounts and promotions
* Refund processing
* Recommendation systems
* Production deployment
* Distributed database architecture

These may be considered in later iterations.

---

## 4. Functional Requirements

### FR-01 - Customer Management

The system must store customer information.

### FR-02 - Customer Addresses

A customer must be able to have one or more addresses.

### FR-03 - Product Management

The system must store product information including product identification
and oricing information.

### FR-04 - Categories

Products must be assignable to categories.
A product may belong to multiple categories.

### FR-05 - Order Creation

A customer must be able to place orders.

### FR-06 - Order Items

An order must contain one or more order items.
Each order item represents a product included in an order.

### FR-07 - Historical Order Pricing

The system must preserve the price of a product at the time it was ordered.
Changes to the current product price must not change the historical financial
value of an existing order.

### FR-08 - Payment Records

The system must store payment information associated with orders.
The design should allow more than one payment record for an order.

### FR-09 - Referential Integrity

Relationships between entities must be protected against invalid references.
For example, an order must not reference a customer that does not exist.

### FR-10 - Transactional Operations

Operations that modify multiple related records must be capable of being 
executed atomically.
For example, creating an order and its order items should not leave the
database in a partially completed state.

---

## 5. Non-Functional Reuirenments

### NFR-01 — Data Integrity

The database should prevent invalid or inconsistent data wherever database-level constraints can reasonably enforce the rule.

### NFR-02 — Consistency

Related records should remain logically consistent after successful operations.

### NFR-03 — Reliability

A failed transactional operation should not leave unintended partial changes.

### NFR-04 — Maintainability

The schema, SQL, and documentation should be understandable to another developer.

### NFR-05 — Performance

Common queries should have reasonable performance, and indexing decisions should be based on actual access patterns rather than added blindly.

### NFR-06 — Testability

Important database behavior should be testable, including constraints, relationships, and transactional behavior.

---

## 6. Assumptions

The first version assumes:

* Each customer has a unique identity.
* Each product has a unique identity.
* Each order belongs to one customer.
* Each order item belongs to one order and references one product.
* Product prices may change over time.
* An order records the relevant product price at the time of purchase.
* An order may have multiple payment records.
* Products may belong to multiple categories.

These assumptions may be revised as the design develops.

---

## 7. Future Data Engineering Use

This database will initially represent an OLTP system.

Later projects will use this system as a source for:

* data extraction
* incremental loading
* ETL / ELT
* data quality checks
* analytical modeling
* data warehouse development
* orchestration
* analytics

This makes Project 01 the starting point for the larger Data Engineering
learning portfolio.
