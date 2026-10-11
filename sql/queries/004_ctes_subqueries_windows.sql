
-- CTE

WITH order_totals AS (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS order_value
    FROM order_items
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.customer_id,
    o.status,
    o.created_at,
    ot.order_value
FROM orders AS o
LEFT JOIN order_totals AS ot
    ON ot.order_id = o.order_id
ORDER BY o.created_at DESC;

-- Subquery

SELECT
    product_id,
    name,
    price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
)
ORDER BY price DESC;


SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM customers AS c
WHERE EXISTS (              -- NOT EXISTS
    SELECT 1
    FROM orders AS o
    WHERE o.customer_id = c.customer_id
);

-- Window functions

-- SELECT
--     customer_id,
--     COUNT(*) AS order_count
-- FROM orders
-- GROUP BY customer_id;


SELECT
    customer_id,
    order_id,
    created_at,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY created_at, order_id
    ) AS order_sequence
FROM orders
ORDER BY customer_id, created_at, order_id;


WITH ranked_orders AS (
    SELECT
        order_id,
        customer_id,
        status,
        created_at,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY created_at DESC, order_id DESC
        ) AS rn
    FROM orders
)
SELECT
    order_id,
    customer_id,
    status,
    created_at
FROM ranked_orders
WHERE rn = 1
ORDER BY customer_id;


WITH product_sales AS (
    SELECT
        product_id,
        SUM(quantity * unit_price) AS sales_value
    FROM order_items
    GROUP BY product_id
)
SELECT
    p.product_id,
    p.name,
    COALESCE(ps.sales_value, 0) AS sales_value,
    RANK() OVER (
        ORDER BY COALESCE(ps.sales_value, 0) DESC
    ) AS sales_rank
FROM products AS p
LEFT JOIN product_sales AS ps
    ON ps.product_id = p.product_id
ORDER BY sales_rank, p.product_id;


WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.created_at,
        COALESCE(
            SUM(oi.quantity * oi.unit_price),
            0
        ) AS order_value
    FROM orders AS o
    LEFT JOIN order_items AS oi
        ON oi.order_id = o.order_id
    GROUP BY
        o.order_id,
        o.customer_id,
        o.created_at
)
SELECT
    customer_id,
    order_id,
    created_at,
    order_value,
    SUM(order_value) OVER (
        PARTITION BY customer_id
        ORDER BY created_at, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_order_value
FROM order_totals
ORDER BY customer_id, created_at, order_id;


WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.created_at,
        COALESCE(
            SUM(oi.quantity * oi.unit_price),
            0
        ) AS order_value
    FROM orders AS o
    LEFT JOIN order_items AS oi
        ON oi.order_id = o.order_id
    GROUP BY
        o.order_id,
        o.customer_id,
        o.created_at
),
order_history AS (
    SELECT
        customer_id,
        order_id,
        created_at,
        order_value,
        LAG(order_value) OVER (
            PARTITION BY customer_id
            ORDER BY created_at, order_id
        ) AS previous_order_value
    FROM order_totals
)
SELECT
    customer_id,
    order_id,
    created_at,
    order_value,
    previous_order_value,
    order_value - previous_order_value AS change_from_previous
FROM order_history
ORDER BY customer_id, created_at, order_id;
