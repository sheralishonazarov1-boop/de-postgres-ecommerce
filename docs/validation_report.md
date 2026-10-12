# Project 01 — Validation Report

## Purpose

Verify that the e-commerce database can be built
from a clean PostgreSQL database using repository SQL files.

## Environment

- Database: ecommerce_validation
- PostgreSQL version: [record your actual version]
- Validation date: [record the date]

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

## Expected results

- Customer, product, category, order and item counts
  match the documented fixture.
- Customer order counts are 2, 1 and 0.
- Keyboard item value is 99.98.
- Mouse item value is 59.97.
- Monitor has zero order items.
- Data-quality checks return no violating rows.
- All five constraint tests report PASS.

## Results

[Document the tests that actually passed and any failures.]

## Known limitations

- The fixture does not contain address or payment records.
- Item value is not automatically recognized revenue.
- Performance depends on the PostgreSQL environment and data.