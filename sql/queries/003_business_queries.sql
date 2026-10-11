-- SELECT
--     c.customer_id,
--     c.first_name,
--     c.last_name,
--     COUNT(o.order_id) AS order_count
-- FROM customers AS c
-- LEFT JOIN orders AS o
--     ON o.customer_id = c.customer_id
-- GROUP BY
--     c.customer_id,
--     c.first_name,
--     c.last_name
-- ORDER BY order_count DESC;


-- SELECT
--     o.order_id,
--     COALESCE(i.order_item_value, 0) AS order_item_value,
--     COALESCE(p.recorded_payment_total, 0) AS recorded_payment_total
-- FROM orders AS o
-- LEFT JOIN (
--     SELECT
--         order_id,
--         SUM(quantity * unit_price) AS order_item_value
--     FROM order_items
--     GROUP BY order_id
-- ) AS i
--     ON i.order_id = o.order_id
-- LEFT JOIN (
--     SELECT
--         order_id,
--         SUM(amount) AS recorded_payment_total
--     FROM payments
--     GROUP BY order_id
-- ) AS p
--     ON p.order_id = o.order_id;


-- FROM orders o
-- LEFT JOIN (
--     SELECT order_id, SUM(quantity * unit_price) AS order_item_value
--     FROM order_items
--     GROUP BY order_id
-- ) AS i ON i.order_id = o.order_id
-- LEFT JOIN (
--     SELECT order_id, SUM(amount) AS recorded_payment_total
--     FROM payments
--     GROUP BY order_id
-- ) AS p ON p.order_id = o.order_id



--- Order details

SELECT 
    o.order_id, c.first_name, c.last_name, o.status, p.name as product_name,
    oi.quantity, oi.unit_price, (oi.quantity * oi.unit_price) as line_total
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
ORDER BY o.order_id, p.name;

--- Product performance

SELECT 
    p.name product_name, SUM(oi.quantity) total,
    SUM(oi.quantity * oi.unit_price) order_line_value
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.name
ORDER BY SUM(oi.quantity * oi.unit_price) DESC;

--- Customer order counts

SELECT 
    c.customer_id, c.first_name, c.last_name,
    COUNT(o.order_id) order_count
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY order_count;

--- Accurate order summary

SELECT 
    o.order_id,
    COALESCE(i.order_item_value, 0) order_item_value,
    COALESCE(p.recorded_payment_total, 0) recorded_payment_total
FROM orders o
LEFT JOIN (
    SELECT 
        order_id,
        SUM(quantity * unit_price) order_item_value
    FROM order_items
    GROUP BY order_id
) AS i
    ON i.order_id = o.order_id
LEFT JOIN (
    SELECT
        order_id,
        SUM(amount) recorded_payment_total
    FROM payments
    GROUP BY order_id
) AS p
    ON p.order_id = o.order_id;


