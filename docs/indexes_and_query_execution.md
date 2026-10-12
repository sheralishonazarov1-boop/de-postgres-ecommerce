# Indexes and Query Execution

An index is a separate on-disk structure that helps PostgreSQL locate rows
without scanning a whole table. Indexes can also support joins, ordering, and
range conditions.

## B-tree and Trade-Offs

B-tree is PostgreSQL's default index type because it supports equality,
ordering, and range comparisons for many common data types. Other index types
serve specialized workloads.

Every index uses storage and adds work to inserts, updates, and deletes. Start
from an actual query pattern, then measure; indexing every column is not a
performance strategy.

## Reading Plans

- `EXPLAIN` reports the planner's estimated plan without executing the query.
- `EXPLAIN (ANALYZE, BUFFERS)` executes the query and reports actual row counts,
	timing, and buffer activity. `ANALYZE` really runs statements, so use it
	carefully with statements that have side effects.
- Compare estimated with actual row counts. Large differences can indicate
	stale statistics or assumptions the planner got wrong.

The lab builds 200,000 rows and compares a customer lookup before and after an
index. A selective lookup can benefit from an index, while retrieving a large
fraction of a table may be cheaper with a sequential scan. Plans and elapsed
times depend on data distribution, cache state, and hardware.

After large data changes, `ANALYZE` refreshes planner statistics. An index
existing in the catalog does not guarantee it will be used.

