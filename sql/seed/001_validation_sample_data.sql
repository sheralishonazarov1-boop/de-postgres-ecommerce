-- Project 01: deterministic validation fixtures.
-- Run only against a fresh validation database.

BEGIN;

-- Three customers: the third has no orders.
INSERT INTO customers (
    first_name,
    last_name,
    email,
    phone,
    created_at
)
VALUES
    (
        'Ada', 'Lovelace',
        'ada@example.test', '+10000000001',
        TIMESTAMPTZ '2026-01-10 09:00:00+00'
    ),
    (
        'Grace', 'Hopper',
        'grace@example.test', '+10000000002',
        TIMESTAMPTZ '2026-01-10 09:30:00+00'
    ),
    (
        'Lin', 'Chen',
        'lin@example.test', '+10000000003',
        TIMESTAMPTZ '2026-01-10 10:00:00+00'
    );

-- Three products: Monitor will have no order items.
INSERT INTO products (
    sku,
    name,
    price,
    created_at,
    active
)
VALUES
    (
        'KB-001', 'Keyboard', 49.99,
        TIMESTAMPTZ '2026-01-01 09:00:00+00',
        TRUE
    ),
    (
        'MS-001', 'Mouse', 19.99,
        TIMESTAMPTZ '2026-01-01 09:00:00+00',
        TRUE
    ),
    (
        'MN-001', 'Monitor', 199.99,
        TIMESTAMPTZ '2026-01-01 09:00:00+00',
        TRUE
    );

INSERT INTO categories (name)
VALUES ('Accessories'), ('Displays');

-- Link the products to their categories.
INSERT INTO product_categories (product_id, category_id)
SELECT p.product_id, c.category_id
FROM products AS p
CROSS JOIN categories AS c
WHERE
    (p.sku IN ('KB-001', 'MS-001')
        AND c.name = 'Accessories')
    OR
    (p.sku = 'MN-001'
        AND c.name = 'Displays');

-- Three orders, all with a valid pending status.
INSERT INTO orders (
    customer_id,
    status,
    created_at
)
SELECT
    c.customer_id,
    'pending',
    v.order_time
FROM (
    VALUES
        (
            'ada@example.test',
            TIMESTAMPTZ '2026-01-10 10:00:00+00'
        ),
        (
            'ada@example.test',
            TIMESTAMPTZ '2026-01-11 10:00:00+00'
        ),
        (
            'grace@example.test',
            TIMESTAMPTZ '2026-01-12 10:00:00+00'
        )
) AS v(customer_email, order_time)
JOIN customers AS c
    ON c.email = v.customer_email;

-- Historical item prices are recorded on each order item.
INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    unit_price
)
SELECT
    o.order_id,
    p.product_id,
    v.quantity,
    v.unit_price
FROM (
    VALUES
        (
            'ada@example.test',
            TIMESTAMPTZ '2026-01-10 10:00:00+00',
            'KB-001',
            1,
            49.99::NUMERIC(12,2)
        ),
        (
            'ada@example.test',
            TIMESTAMPTZ '2026-01-10 10:00:00+00',
            'MS-001',
            2,
            19.99::NUMERIC(12,2)
        ),
        (
            'ada@example.test',
            TIMESTAMPTZ '2026-01-11 10:00:00+00',
            'KB-001',
            1,
            49.99::NUMERIC(12,2)
        ),
        (
            'grace@example.test',
            TIMESTAMPTZ '2026-01-12 10:00:00+00',
            'MS-001',
            1,
            19.99::NUMERIC(12,2)
        )
) AS v(
    customer_email,
    order_time,
    sku,
    quantity,
    unit_price
)
JOIN customers AS c
    ON c.email = v.customer_email
JOIN orders AS o
    ON o.customer_id = c.customer_id
   AND o.created_at = v.order_time
JOIN products AS p
    ON p.sku = v.sku;

COMMIT;


SELECT 'customers' AS table_name, COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'product_categories', COUNT(*) FROM product_categories
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'addresses', COUNT(*) FROM addresses
ORDER BY table_name;

-- Business query results

SELECT
    c.email,
    COUNT(o.order_id) AS order_count
FROM customers AS c
LEFT JOIN orders AS o
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.email
ORDER BY c.email;

-- Product performance

SELECT
    p.sku,
    COALESCE(SUM(oi.quantity), 0) AS units_sold,
    COALESCE(
        SUM(oi.quantity * oi.unit_price),
        0
    ) AS item_value
FROM products AS p
LEFT JOIN order_items AS oi
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.sku
ORDER BY p.sku;

-- Latest Order Analysis

WITH ranked_orders AS (
    SELECT
        o.order_id,
        c.email,
        o.created_at,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.created_at DESC, o.order_id DESC
        ) AS rn
    FROM orders AS o
    JOIN customers AS c
        ON c.customer_id = o.customer_id
)
SELECT
    email,
    created_at
FROM ranked_orders
WHERE rn = 1
ORDER BY email;

-- psql -v ON_ERROR_STOP=1 \
--     -d ecommerce_validation \
--     -f sql/tests/002_data_quality_checks.sql

SELECT
    version,
    description,
    applied_at
FROM schema_migrations
ORDER BY applied_at;


SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'orders'
  AND column_name = 'cancellation_recorded_at';


