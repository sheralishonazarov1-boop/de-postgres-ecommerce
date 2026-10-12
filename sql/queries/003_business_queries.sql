-- Item totals use the price recorded on each order line, not today's price.

-- Order details: one result row per order item.
SELECT
    o.order_id,
    c.first_name,
    c.last_name,
    o.status,
    p.sku,
    p.name AS product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS line_total
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
JOIN order_items AS oi
    ON oi.order_id = o.order_id
JOIN products AS p
    ON p.product_id = oi.product_id
ORDER BY o.order_id, oi.order_item_id;

-- Product performance: include products that have not sold yet.
SELECT
    p.product_id,
    p.sku,
    p.name AS product_name,
    COALESCE(SUM(oi.quantity), 0) AS units_sold,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS item_value
FROM products AS p
LEFT JOIN order_items AS oi
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.sku, p.name
ORDER BY item_value DESC, p.product_id;

-- COUNT(order_id) excludes the NULL row produced by a customer's LEFT JOIN.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS order_count
FROM customers AS c
LEFT JOIN orders AS o
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY order_count DESC, c.customer_id;

-- Aggregate each one-to-many relationship before joining to avoid fan-out.
WITH item_totals AS (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS item_total
    FROM order_items
    GROUP BY order_id
),
payment_totals AS (
    SELECT
        order_id,
        SUM(amount) AS payment_total
    FROM payments
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.status,
    COALESCE(i.item_total, 0) AS item_total,
    COALESCE(p.payment_total, 0) AS recorded_payment_total
FROM orders AS o
LEFT JOIN item_totals AS i
    ON i.order_id = o.order_id
LEFT JOIN payment_totals AS p
    ON p.order_id = o.order_id
ORDER BY o.order_id;


