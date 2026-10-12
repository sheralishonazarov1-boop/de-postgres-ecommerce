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