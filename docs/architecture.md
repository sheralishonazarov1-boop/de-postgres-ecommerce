# Project 01 — Architecture

## 1. System Context

The project represents the operational database of a small e-commerce system.

The database is intended to support transactional application operations such as:

* creating customers
* managing addresses
* managing products
* creating orders
* adding products to orders
* recording payments

---

## 2. Architectural Role

The PostgreSQL database represents the OLTP layer of the system.

High-level conceptual flow:

Application
↓
PostgreSQL OLTP Database
↓
Future Data Engineering Pipelines
↓
Future Analytical Storage / Warehouse
↓
Future Analytics / BI

The analytical components are outside the scope of Project 01 and will be implemented in later projects.

---

## 3. Main Domain Entities

The current domain model contains the following entities:

* Customer
* Address
* Product
* Category
* ProductCategory
* Order
* OrderItem
* Payment

The exact attributes and constraints will be determined during the database design phase.

---

## 4. Relationship Model

The current conceptual relationships are:

Customer → Address

One customer may have multiple addresses.

Customer → Order

One customer may place multiple orders.

Order → OrderItem

One order may contain multiple order items.

Product → OrderItem

One product may appear in many order items.

Product ↔ Category

Products and categories form a many-to-many relationship, implemented through ProductCategory.

Order → Payment

One order may have multiple payment records.

---

## 5. Technology

Primary database:

PostgreSQL

Version-specific details will be documented after the local development environment is established.

---

## 6. Design Principles

The database will prioritize:

* data integrity
* clear relational modeling
* appropriate normalization
* explicit business rules
* transactional correctness
* maintainability
* measurable performance

Performance optimizations will be introduced only after identifying a real access pattern or measurable problem.

---

## 7. Future Architecture

Later iterations of the Data Engineering portfolio may extend this system into:

Application
↓
PostgreSQL
↓
Extraction / CDC
↓
Raw Storage
↓
Transformation
↓
Analytical Warehouse
↓
Data Mart
↓
BI

The exact technology choices will be made in later projects.
