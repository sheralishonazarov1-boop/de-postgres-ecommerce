# Database Migrations

A migration is a small, ordered, reviewable schema change committed with the
application or queries that depend on it.

## Expand, Migrate, Contract

1. **Expand:** add a compatible column or structure without immediately
	removing the old one.
2. **Migrate:** update application behavior, backfill data when needed, and
	verify correctness.
3. **Contract:** remove the old structure only after its consumers have moved.

## Project Migration

`sql/migrations/001_add_cancellation_recorded_at.sql` adds a nullable
`timestamptz` column to `orders`, adds a check constraint, and records the
version in `schema_migrations`. The statements are wrapped in one transaction,
so a failure does not leave a partial migration.

The validation script applies this migration once to a fresh database. The
file is not an automated migration runner and is not safe to replay against a
database where the column already exists. Production migration systems also
need locking, checksums, rollback policy, and deployment coordination.