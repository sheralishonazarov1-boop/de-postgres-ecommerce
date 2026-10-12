# Transactions and Isolation

A transaction groups statements into one unit of work. `COMMIT` makes all
changes visible together; `ROLLBACK` discards the transaction's changes. An
order-creation workflow should insert its order, items, and payment records
atomically so a failure cannot leave a partial order.

## ACID

- **Atomicity:** all statements in the transaction succeed together or are
	rolled back together.
- **Consistency:** constraints and application rules remain true before and
	after a committed transaction.
- **Isolation:** concurrent transactions observe data according to the chosen
	isolation level.
- **Durability:** committed changes survive a server restart, subject to the
	database's durability configuration.

## Recovering from an Error

In PostgreSQL, a statement error aborts the current transaction. Later
statements are rejected until the transaction is rolled back. Use `ROLLBACK`
to abandon all its changes, or `ROLLBACK TO SAVEPOINT` when the transaction
has established a savepoint. A `COMMIT` issued while the transaction is
aborted does not commit the failed work.

## PostgreSQL Isolation Levels

| Level | Snapshot behavior | Important consequence |
| --- | --- | --- |
| Read Uncommitted | Behaves like Read Committed in PostgreSQL | Dirty reads are not possible. |
| Read Committed | Each statement sees a fresh committed snapshot | Repeating a query can return changed rows or new matching rows. |
| Repeatable Read | Statements use a stable transaction snapshot | Non-repeatable and phantom reads are prevented, but serialization anomalies can still occur. |
| Serializable | Transactions behave as if run in some serial order | PostgreSQL can abort a transaction; applications must be ready to retry it. |

At Read Committed, a transaction sees another transaction's changes only after
they commit and a later statement takes a new snapshot. Repeatable Read keeps
the transaction's snapshot stable. PostgreSQL's Repeatable Read is snapshot
isolation, not a promise that every concurrent schedule is serializable.

## Two-Session Exercise

Use the `transaction_lab_accounts` table created by
`sql/labs/001_transaction.sql`.

1. In session A, run `BEGIN; SELECT balance FROM transaction_lab_accounts WHERE account_id = 1;`.
2. In session B, update account 1 and commit.
3. In session A, repeat the `SELECT` under Read Committed. Then start a new
	transaction with `BEGIN ISOLATION LEVEL REPEATABLE READ;` and repeat the
	exercise to compare snapshots.
4. Compare the snapshots and roll back any uncommitted test work.

The lab's transfer moves money between two rows in one transaction. If either
update fails, rolling back restores both balances; committing only after both
updates succeeds preserves the account-total invariant.