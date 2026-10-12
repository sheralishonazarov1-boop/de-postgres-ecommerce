# Project 01 — Validation Report

## Purpose

Verify that the e-commerce database can be built
from a clean PostgreSQL database using repository SQL files.

## Environment

- Database: `ecommerce_github_constraints_final`
- PostgreSQL version: 16 (Docker image `postgres:16`)
- Validation date: 2026-10-12

## Build sequence

1. Initial schema
2. Index definitions
3. Cancellation timestamp migration
4. Deterministic validation fixture

## Validation performed

- Table row counts
- Constraint tests
- Read-only data-quality checks
- Business-query expected results
- Analytical-query behavior
- Migration ledger and new column
- Index-plan experiment
- Payment-to-order total reconciliation

## Expected results

- 3 customers, 3 addresses, 3 products, 2 categories, 3 product-category
  links, 3 orders, 4 order items, and 3 payment records.
- Customer order counts are 2, 1 and 0.
- Keyboard item value is 99.98.
- Mouse item value is 59.97.
- Monitor has zero order items.
- Ada's two paid orders reconcile to recorded payments, including two payment
  records for the January 10 order.
- Captured payment total is 139.96.
- Data-quality checks return no violating rows.
- All eight constraint tests report PASS.

## Results

The full `scripts/validate.sh` run completed successfully on PostgreSQL 16.
Schema creation, migration, deterministic seed, all six constraint tests,
data-quality assertions, business and analytical queries, the account-transfer
lab, the 200,000-row index lab, and integration assertions completed without a
reported SQL error. The customer lookup changed from a sequential scan to a
bitmap index scan after index creation. Execution times are
environment-dependent and are not treated as benchmarks.

## Known limitations

- The database permits orders with no items while they are being assembled;
  the minimum-one-item checkout rule is not enforced by a database constraint.
- Item value is not automatically recognized revenue.
- Payment statuses and methods remain open text pending business rules.
- Performance plans and timings depend on PostgreSQL, data, and hardware.