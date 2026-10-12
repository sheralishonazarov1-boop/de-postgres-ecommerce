BEGIN;

DROP TABLE IF EXISTS transaction_lab_accounts;

CREATE TABLE transaction_lab_accounts (
    account_id BIGINT PRIMARY KEY,
    owner_name VARCHAR(100) NOT NULL,
    balance NUMERIC(12, 2) NOT NULL CHECK (balance >= 0)
);

INSERT INTO transaction_lab_accounts (
    account_id,
    owner_name,
    balance
)
VALUES
    (1, 'Alice', 1000.00),
    (2, 'Bob', 1000.00);

COMMIT;

SELECT *
FROM transaction_lab_accounts
ORDER BY account_id;

BEGIN;

UPDATE transaction_lab_accounts
SET balance = balance - 100.00
WHERE account_id = 1;

UPDATE transaction_lab_accounts
SET balance = balance + 100.00
WHERE account_id = 2;

COMMIT;

SELECT *
FROM transaction_lab_accounts
ORDER BY account_id;


