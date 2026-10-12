-- Project 01: known-answer integration assertions.
-- Run against the seeded ecommerce_validation database.

DO $$
DECLARE
    actual_count BIGINT;
    actual_total NUMERIC;
BEGIN
    -- Verify the validation fixture.
    SELECT COUNT(*) INTO actual_count FROM customers;

    IF actual_count <> 3 THEN
        RAISE EXCEPTION
            'Expected 3 customers, got %', actual_count;
    END IF;

    SELECT COUNT(*) INTO actual_count FROM products;

    IF actual_count <> 3 THEN
        RAISE EXCEPTION
            'Expected 3 products, got %', actual_count;
    END IF;

    SELECT COUNT(*) INTO actual_count FROM orders;

    IF actual_count <> 3 THEN
        RAISE EXCEPTION
            'Expected 3 orders, got %', actual_count;
    END IF;

    SELECT COUNT(*) INTO actual_count FROM order_items;

    IF actual_count <> 4 THEN
        RAISE EXCEPTION
            'Expected 4 order items, got %', actual_count;
    END IF;

    SELECT COUNT(*) INTO actual_count FROM addresses;

    IF actual_count <> 3 THEN
        RAISE EXCEPTION
            'Expected 3 addresses, got %', actual_count;
    END IF;

    SELECT COUNT(*) INTO actual_count FROM payments;

    IF actual_count <> 3 THEN
        RAISE EXCEPTION
            'Expected 3 payment records, got %', actual_count;
    END IF;

    IF (
        SELECT COUNT(*)
        FROM payments AS p
        JOIN orders AS o
            ON o.order_id = p.order_id
        WHERE o.created_at = TIMESTAMPTZ '2026-01-10 10:00:00+00'
    ) <> 2 THEN
        RAISE EXCEPTION
            'Expected Ada January 10 order to have two payment records';
    END IF;

    IF EXISTS (
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
        SELECT 1
        FROM orders AS o
        LEFT JOIN item_totals AS i
            ON i.order_id = o.order_id
        LEFT JOIN payment_totals AS p
            ON p.order_id = o.order_id
        WHERE o.status = 'paid'
          AND COALESCE(i.item_total, 0)
              <> COALESCE(p.payment_total, 0)
    ) THEN
        RAISE EXCEPTION
            'Paid order item totals must match recorded payments';
    END IF;

    -- Verify the total recorded order-item value.
    SELECT COALESCE(SUM(quantity * unit_price), 0)
    INTO actual_total
    FROM order_items;

    IF actual_total <> 159.95 THEN
        RAISE EXCEPTION
            'Expected item value 159.95, got %', actual_total;
    END IF;

    -- Verify the keyboard's recorded item value.
    SELECT COALESCE(SUM(oi.quantity * oi.unit_price), 0)
    INTO actual_total
    FROM order_items AS oi
    JOIN products AS p
        ON p.product_id = oi.product_id
    WHERE p.sku = 'KB-001';

    IF actual_total <> 99.98 THEN
        RAISE EXCEPTION
            'Expected keyboard item value 99.98, got %',
            actual_total;
    END IF;

    SELECT COALESCE(SUM(amount), 0)
    INTO actual_total
    FROM payments;

    IF actual_total <> 139.96 THEN
        RAISE EXCEPTION
            'Expected captured payment total 139.96, got %', actual_total;
    END IF;

    -- Verify the customer without orders is still present.
    IF NOT EXISTS (
        SELECT 1
        FROM customers AS c
        WHERE c.email = 'lin@example.test'
          AND NOT EXISTS (
              SELECT 1
              FROM orders AS o
              WHERE o.customer_id = c.customer_id
          )
    ) THEN
        RAISE EXCEPTION
            'Expected Lin to exist without any orders';
    END IF;

    -- Verify the migration was recorded.
    IF NOT EXISTS (
        SELECT 1
        FROM schema_migrations
        WHERE version = '001_add_cancellation_recorded_at'
    ) THEN
        RAISE EXCEPTION
            'Cancellation timestamp migration not recorded';
    END IF;

    -- Verify the intended index exists.
    IF to_regclass(
        'public.idx_orders_customer_created_at'
    ) IS NULL THEN
        RAISE EXCEPTION
            'Expected customer/order-time index is missing';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conrelid = 'public.orders'::regclass
          AND conname = 'chk_orders_status'
    ) THEN
        RAISE EXCEPTION
            'Expected order status constraint is missing';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM transaction_lab_accounts
        HAVING SUM(balance) = 2000.00
           AND MIN(balance) = 900.00
           AND MAX(balance) = 1100.00
    ) THEN
        RAISE EXCEPTION
            'Transaction lab did not preserve the account balances';
    END IF;

    RAISE NOTICE 'PASS: all validation assertions succeeded';
END
$$;


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
ORDER BY t.relname, c.conname;


