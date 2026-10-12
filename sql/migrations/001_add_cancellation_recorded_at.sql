BEGIN;

-- Create a record of applied migrations.
CREATE TABLE IF NOT EXISTS schema_migrations (
    version TEXT PRIMARY KEY,
    description TEXT NOT NULL,
    applied_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Add the new column to the existing orders table.
ALTER TABLE orders
ADD COLUMN cancellation_recorded_at TIMESTAMPTZ;

-- A recorded cancellation timestamp is only valid
-- when the order's current status is 'cancelled'.
ALTER TABLE orders
ADD CONSTRAINT orders_cancellation_timestamp_status_check
CHECK (
    cancellation_recorded_at IS NULL
    OR status = 'cancelled'
);

-- Record the migration only if the preceding changes succeed.
INSERT INTO schema_migrations (version, description)
VALUES (
    '001_add_cancellation_recorded_at',
    'Add cancellation timestamp to orders'
);

COMMIT;


SELECT
    conname,
    pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid = 'public.orders'::regclass
  AND conname = 'orders_cancellation_timestamp_status_check';

-- Migration History

SELECT
    version,
    description,
    applied_at
FROM schema_migrations
ORDER BY applied_at;

