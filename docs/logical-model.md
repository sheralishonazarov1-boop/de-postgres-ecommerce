# Project 01 — Logical Data Model

## 1. Purpose

This document defines the logical relational model for the e-commerce transaction database.

The model translates the conceptual business entities and relationships into relational structures with attributes, keys, and relationships.

---

## 2. Relations

### Customers

| Attribute   | Purpose                     |
| ----------- | --------------------------- |
| customer_id | Unique customer identifier  |
| first_name  | Customer first name         |
| last_name   | Customer last name          |
| email       | Customer email address      |
| phone       | Customer phone number       |
| created_at  | Customer creation timestamp |

Primary Key: `customer_id`

Candidate/business uniqueness: `email`

---

### Addresses

| Attribute    | Purpose                       |
| ------------ | ----------------------------- |
| address_id   | Unique address identifier     |
| customer_id  | Customer who owns the address |
| address_type | Type of address               |
| street       | Street information            |
| city         | City                          |
| country      | Country                       |

Primary Key: `address_id`

Foreign Key: `customer_id → customers.customer_id`

---

### Products

| Attribute  | Purpose                                 |
| ---------- | --------------------------------------- |
| product_id | Unique product identifier               |
| sku        | Business product identifier             |
| name       | Product name                            |
| price      | Current product price                   |
| created_at | Product creation timestamp              |
| active     | Whether the product is currently active |

Primary Key: `product_id`

Candidate/business uniqueness: `sku`

---

### Categories

| Attribute   | Purpose                    |
| ----------- | -------------------------- |
| category_id | Unique category identifier |
| name        | Category name              |

Primary Key: `category_id`

Uniqueness: `name`

---

### ProductCategory

| Attribute   | Purpose             |
| ----------- | ------------------- |
| product_id  | Associated product  |
| category_id | Associated category |

Composite Primary Key:

`(product_id, category_id)`

Foreign Keys:

`product_id → products.product_id`

`category_id → categories.category_id`

This relation implements the many-to-many relationship between products and categories.

---

### Orders

| Attribute   | Purpose                       |
| ----------- | ----------------------------- |
| order_id    | Unique order identifier       |
| customer_id | Customer who placed the order |
| status      | Current order status          |
| created_at  | Order creation timestamp      |

Primary Key: `order_id`

Foreign Key: `customer_id → customers.customer_id`

---

### OrderItem

| Attribute     | Purpose                         |
| ------------- | ------------------------------- |
| order_item_id | Unique order-line identifier    |
| order_id      | Associated order                |
| product_id    | Purchased product               |
| quantity      | Number of units purchased       |
| unit_price    | Price per unit at purchase time |

Primary Key: `order_item_id`

Foreign Keys:

`order_id → orders.order_id`

`product_id → products.product_id`

The `unit_price` attribute preserves the historical transaction price and is intentionally distinct from the current `products.price`.

---

### Payments

| Attribute      | Purpose                   |
| -------------- | ------------------------- |
| payment_id     | Unique payment identifier |
| order_id       | Associated order          |
| amount         | Payment amount            |
| status         | Payment status            |
| payment_method | Method used for payment   |
| created_at     | Payment timestamp         |

Primary Key: `payment_id`

Foreign Key: `order_id → orders.order_id`

---

## 3. Relationship Summary

* Customer 1:N Address
* Customer 1:N Order
* Order 1:N OrderItem
* Product 1:N OrderItem
* Product N:M Category through ProductCategory
* Order 1:N Payment

---

## 4. Key Strategy

Surrogate identifiers are used as the primary identifiers for the major business entities.

Business identifiers such as customer email and product SKU are treated separately as unique business attributes.

ProductCategory uses a composite primary key because the pair `(product_id, category_id)` identifies a unique product-category association.

---

## 5. Nullability

Required attributes will be implemented as non-nullable where the business rules require their presence.

Optional attributes will remain nullable unless a stronger business rule is established.

Current optionality that remains intentionally unresolved will be documented before physical implementation.

---

## 6. Important Modeling Decision

`products.price` and `order_items.unit_price` intentionally represent different facts.

* `products.price` represents the current product price.
* `order_items.unit_price` represents the historical transaction price at the time of purchase.

The duplication is therefore semantic rather than accidental.

---

## 7. Next Design Validation

Before physical database implementation, the logical model will be checked against:

* 1NF
* 2NF
* 3NF
* functional dependencies
* referential integrity
* nullability
* business constraints
* indexing requirements

Only after this validation will the model be translated into PostgreSQL DDL.
