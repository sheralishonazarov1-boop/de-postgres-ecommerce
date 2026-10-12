SELECT
    email,
    COUNT(*) AS occurrences
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

SELECT
    sku,
    COUNT(*) AS occurrences
FROM products
GROUP BY sku
HAVING COUNT(*) > 1;

SELECT
    product_id,
    sku,
    name,
    price
FROM products
WHERE price IS NULL
   OR price < 0;

SELECT
    order_item_id,
    order_id,
    product_id,
    quantity
FROM order_items
WHERE quantity IS NULL
   OR quantity <= 0;

SELECT
    p.payment_id,
    p.order_id
FROM payments AS p
LEFT JOIN orders AS o
    ON o.order_id = p.order_id
WHERE o.order_id IS NULL;

---

SELECT
    t.relname AS table_name,
    c.conname AS constraint_name,
    c.contype AS constraint_type,
    pg_get_constraintdef(c.oid) AS definition
FROM pg_constraint AS c
JOIN pg_class AS t
    ON t.oid = c.conrelid
JOIN pg_namespace AS n
    ON n.oid = t.relnamespace
WHERE n.nspname = 'public'
  AND t.relname IN (
      'customers',
      'addresses',
      'products',
      'categories',
      'product_categories',
      'orders',
      'order_items',
      'payments'
  )
ORDER BY t.relname, c.conname;


SELECT
    table_name,
    column_name,
    is_nullable,
    data_type,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN (
      'customers',
      'addresses',
      'products',
      'product_categories',
      'orders',
      'order_items',
      'payments'
  )
ORDER BY table_name, ordinal_position;


