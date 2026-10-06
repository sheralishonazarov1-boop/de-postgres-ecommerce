# Project 01 — Decision Log

This document records important technical and architectural decisions made during the project.

The purpose is not only to record what was chosen, but also why it was chosen and what trade-offs were considered.

---

## ADR-001 — Use PostgreSQL

### Status

Accepted

### Context

The project needs a relational database suitable for learning and demonstrating:

* relational modeling
* primary and foreign keys
* constraints
* transactions
* ACID behavior
* indexes
* query execution plans
* SQL
* concurrency concepts

### Decision

Use PostgreSQL as the primary database for Project 01.

### Reason

PostgreSQL provides a strong environment for studying relational database concepts while also being widely used in real-world software and data systems.

### Consequences

The project will initially be designed around PostgreSQL behavior and SQL.

Database-specific features will be documented when they become relevant.

---

## ADR-002 — Treat the Database as an OLTP System

### Status

Accepted

### Context

The project represents the operational side of an e-commerce application rather than an analytical warehouse.

### Decision

Design the database primarily as an OLTP system.

### Reason

The main operations are transactional:

* creating orders
* modifying records
* recording payments
* maintaining relationships

### Consequences

The schema will prioritize:

* data integrity
* transactional correctness
* normalized operational structures
* reliable writes

An analytical model will be designed later rather than mixing OLTP and analytical concerns into the same initial schema.

---

## ADR-003 — Preserve Historical Order Prices

### Status

Accepted

### Context

Product prices may change over time.

If an order only references the current product price, historical orders could become financially incorrect after a price change.

### Decision

An order item will store the price relevant to that purchase in addition to referencing the product.

### Reason

Historical transaction data must represent what actually happened at the time of the transaction.

### Consequences

Current product pricing and historical order pricing become separate pieces of information.

This will allow product prices to change without altering historical order values.

---

## ADR-004 — Keep the Initial Scope Small

### Status

Accepted

### Context

The project is primarily intended to build strong database engineering foundations.

### Decision

The first version will focus on the core e-commerce transaction model.

### Reason

A smaller coherent system is easier to understand, test, debug, and improve.

### Consequences

Features such as inventory, shipping, refunds, authentication, and production deployment will be postponed.

They can be introduced as later iterations if they provide a useful learning opportunity.

---

## Future Decisions

Additional decisions will be recorded here as the design develops.

Examples may include:

* primary key strategy
* normalization decisions
* index strategy
* deletion behavior
* transaction boundaries
* naming conventions
* migration strategy
* testing strategy
