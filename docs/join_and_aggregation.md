# Joins and Aggregation

## Join Types

An `INNER JOIN` returns rows with matches on both sides. A `LEFT JOIN` retains
all rows from its left input and fills right-side columns with `NULL` when a
match does not exist. Use it when a report must retain customers with no
orders or products with no order items.

## Grouping and Filters

`GROUP BY` combines rows into groups for aggregate calculations. `WHERE`
filters input rows before grouping; `HAVING` filters the groups after the
aggregates have been calculated.

For a left join, `COUNT(*)` counts the preserved parent row even when it has
no child. `COUNT(child.primary_key)` ignores the `NULL` child and returns zero.
The customer-count query demonstrates this distinction.

## Avoiding Fan-Out

If one order has two items and three payment records, joining both child
tables directly creates six rows. Summing the items after that join counts
each item three times; summing payments counts each payment twice. Aggregate
each child table by `order_id` first, then join the one-row-per-order results.
The accurate order summary in `sql/queries/003_business_queries.sql` uses this
pattern.

## Item Value Is Not Revenue

`quantity * unit_price` gives the historical line value. Calling it revenue
requires business rules for cancellations, refunds, discounts, tax, shipping,
and payment state. This project reports item value and recorded payments
separately rather than claiming recognized revenue.