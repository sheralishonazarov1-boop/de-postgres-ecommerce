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

```mermaid
flowchart LR
	APP[Commerce application] --> DB[(PostgreSQL OLTP database)]
	DB --> PIPE[Future extraction and transformation]
	PIPE --> WH[(Future analytical warehouse)]
	WH --> BI[Analytics and BI]
```

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

The implemented attributes and constraints are documented in the
[logical data model](logical-model.md) and [initial schema](../sql/001_initial_schema.sql).

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

### 4.1 Conceptual Model

The system currently contains seven primary business entities:

- Customer
- Address
- Product
- Category
- Order
- OrderItem
- Payment

ProductCategory is an associative entity used to represent the many-to-many
relationship between Product and Category.

Current relationships:

- Customer 1:N Address
- Customer 1:N Order
- Order 1:N OrderItem
- Product 1:N OrderItem
- Product N:M Category through ProductCategory
- Order 1:N Payment

The schema permits zero child rows while a customer has no addresses, a
product has no order items, or an order is still being assembled. The checkout
requirement for at least one order item is currently enforced by application
workflow rather than a database constraint.

---

## 5. Technology

Primary database:

PostgreSQL 16+

The validation workflow runs against PostgreSQL 16. Database-specific
behavior, such as snapshot isolation, is documented where it affects the
learning exercises.

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
