BEGIN:

DROP TABLE IF EXISTS transaction_lab_accounts;

CREATE TABLE transaction_lab_accounts (
    account_id BIGINT PRIMARY KEY,
    owner_name VARCHAR(100) NOT NULL,
    balance NUMERIC(12, 2) NOT NULL
);

INSERT INTO transaction_lab_accounts (
    account_id,
    owner_name,
    balance
)
VALUES
    (1, 'Alice', 1000.00),
    (2, 'Bob', 1000.00);

UPDATE transaction_lab_accounts
SET balance = 1500.00
WHERE account_id = 1;

COMMIT;

select * from transaction_lab_accounts;

BEGIN;

SET balance = 1500.00
WHERE account_id = 1;

COMMIT;


