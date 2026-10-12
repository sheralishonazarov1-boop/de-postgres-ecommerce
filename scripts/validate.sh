#!/usr/bin/env bash
set -Eeuo pipefail

# Project 01: create a fresh validation database,
# build the schema, apply the migration, load fixtures,
# and run the SQL checks.

DB_NAME="${1:-ecommerce_validation}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Restrict the database name to a simple SQL identifier.
if [[ ! "$DB_NAME" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
    echo "ERROR: invalid database name: $DB_NAME" >&2
    exit 1
fi

cd "$ROOT_DIR"

# Confirm required PostgreSQL utilities exist.
for cmd in psql createdb; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: required command not found: $cmd" >&2
        exit 1
    fi
done

# Refuse to overwrite an existing database.
if psql -d postgres -Atqc \
    "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" \
    | grep -q '^1$'; then
    echo "ERROR: database '$DB_NAME' already exists." >&2
    echo "Choose a fresh database name. Nothing was dropped." >&2
    exit 1
fi

echo "Creating validation database: $DB_NAME"
createdb "$DB_NAME"

run_sql_file() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        echo "ERROR: required project file not found: $file" >&2
        exit 1
    fi

    echo
    echo "==> $file"

    psql -X -v ON_ERROR_STOP=1 \
        -d "$DB_NAME" \
        -f "$file"
}

run_sql_file "sql/001_initial_schema.sql"
run_sql_file "sql/002_indexes.sql"
run_sql_file "sql/migrations/001_add_cancellation_recorded_at.sql"
run_sql_file "sql/seed/001_validation_sample_data.sql"

run_sql_file "sql/tests/001_constraint_tests.sql"
run_sql_file "sql/tests/002_data_quality_checks.sql"

run_sql_file "sql/queries/003_business_queries.sql"
run_sql_file "sql/queries/004_ctes_subqueries_windows.sql"

run_sql_file "sql/labs/002_indexes_and_explain.sql"

echo
echo "SQL files completed without a reported psql error."
echo "Validation database: $DB_NAME"
echo "Database retained for manual inspection."
