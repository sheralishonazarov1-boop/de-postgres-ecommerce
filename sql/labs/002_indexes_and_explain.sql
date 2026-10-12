
DROP TABLE IF EXISTS index_lab_orders;

CREATE TABLE index_lab_orders (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    status TEXT NOT NULL
        CHECK (status IN (
            'pending', 'paid', 'shipped', 'cancelled'
        )),
    total_amount NUMERIC(10, 2) NOT NULL
        CHECK (total_amount >= 0),
    created_at TIMESTAMPTZ NOT NULL
);

INSERT INTO index_lab_orders (
    customer_id,
    status,
    total_amount,
    created_at
)
SELECT
    ((g - 1) % 10000) + 1,
    CASE g % 4
        WHEN 0 THEN 'shipped'
        WHEN 1 THEN 'paid'
        WHEN 2 THEN 'pending'
        ELSE 'cancelled'
    END,
    (random() * 490 + 10)::NUMERIC(10, 2),
    NOW()
        - (g % 730) * INTERVAL '1 day'
        - random() * INTERVAL '1 day'
FROM generate_series(1, 200000) AS g;


analyze index_lab_orders;

explain (analyze, buffers)
select *
from index_lab_orders
where customer_id = 4242;

create index idx_index_lab_orders_customer_id
on index_lab_orders (customer_id);


explain (analyze, buffers)
select *                          
from index_lab_orders
where customer_id = 4242;


EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM index_lab_orders
WHERE status = 'shipped';


CREATE INDEX idx_index_lab_orders_status
ON index_lab_orders (status);

ANALYZE index_lab_orders;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM index_lab_orders
WHERE status = 'shipped';


