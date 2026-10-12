# Normalization

Normalization places each fact in one authoritative relation to reduce
inconsistent updates and deletes.

## 1NF

### First Normal Form (1NF)

Store one value per attribute per row. Put repeating values in related rows
instead of comma-separated lists.

## 2NF

### Second Normal Form (2NF)

Every non-key attribute must depend on the whole candidate key. This is most
visible when a relation has a composite key.

## 3NF

### Third Normal Form (3NF)

Non-key attributes depend on the key, the whole key, and nothing but the key.
Facts about a different entity belong in that entity's relation.

## Examples in This Schema

`product_categories` stores one product/category association per row and uses
`(product_id, category_id)` as its composite primary key. Product and category
names remain in their own relations.

`order_items.unit_price` is not an accidental duplicate of `products.price`.
The former is the historical price for an order line; the latter is the
current catalog price. A catalog update must not rewrite past orders.

----

## OLTP

Normalization generally helps transactional systems keep writes consistent.

## OLAP

Analytical systems may deliberately use dimensional models or controlled
denormalization when query patterns justify the trade-off.