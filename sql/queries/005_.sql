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


