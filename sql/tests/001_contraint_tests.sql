-- Project 01, Step 10
-- Disposable fixtures for constraint testing.

BEGIN;

CREATE TEMP TABLE test_customers (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email TEXT NOT NULL UNIQUE
);

CREATE TEMP TABLE test_products (
    product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sku TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    price NUMERIC(12,2) NOT NULL CHECK (price >= 0)
);

CREATE TEMP TABLE test_orders (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL
        REFERENCES test_customers(customer_id),
    status TEXT NOT NULL
        CHECK (
            status IN ('pending', 'paid', 'shipped', 'cancelled')
        )
);


CREATE TEMP TABLE test_order_items (
    order_item_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL
        REFERENCES test_orders(order_id),
    product_id BIGINT NOT NULL
        REFERENCES test_products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    UNIQUE (order_id, product_id)
);

-- Valid

INSERT INTO test_customers (email)
VALUES ('ada@example.test');

INSERT INTO test_products (sku, name, price)
VALUES ('KB-001', 'Keyboard', 49.99);

INSERT INTO test_orders (customer_id, status)
SELECT customer_id, 'pending'
FROM test_customers
WHERE email = 'ada@example.test';

INSERT INTO test_order_items (
    order_id,
    product_id,
    quantity,
    unit_price
)
SELECT
    o.order_id,
    p.product_id,
    1,
    p.price
FROM test_orders AS o
CROSS JOIN test_products AS p;

-- Invalid

DO $$
BEGIN
    BEGIN
        INSERT INTO test_customers (email)
        VALUES (NULL);

        RAISE EXCEPTION
            'FAIL: NULL email was accepted';
    EXCEPTION
        WHEN not_null_violation THEN
            RAISE NOTICE 'PASS: NULL email rejected';
    END;
END
$$;

DO $$
BEGIN
    BEGIN
        INSERT INTO test_customers (email)
        VALUES ('ada@example.test');

        RAISE EXCEPTION
            'FAIL: duplicate email was accepted';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE NOTICE 'PASS: duplicate email rejected';
    END;
END
$$;

DO $$
BEGIN
    BEGIN
        INSERT INTO test_products (sku, name, price)
        VALUES ('BAD-001', 'Invalid Product', -10.00);

        RAISE EXCEPTION
            'FAIL: negative price was accepted';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'PASS: negative price rejected';
    END;
END
$$;

DO $$
BEGIN
    BEGIN
        INSERT INTO test_orders (customer_id, status)
        VALUES (-999, 'pending');

        RAISE EXCEPTION
            'FAIL: nonexistent customer was accepted';
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'PASS: invalid customer reference rejected';
    END;
END
$$;

DO $$
BEGIN
    BEGIN
        INSERT INTO test_order_items (
            order_id, product_id, quantity, unit_price
        )
        SELECT
            o.order_id, p.product_id, 0, p.price
        FROM test_orders AS o
        CROSS JOIN test_products AS p;

        RAISE EXCEPTION
            'FAIL: zero quantity was accepted';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'PASS: zero quantity rejected';
    END;
END
$$;

ROLLBACK;