## What is an index:
* Index is a data structure that is used to locate rows efficiently by saving them in separate memory.

## WHy B-tree is common default:
* It's suitable for many common operations while other index types exist for specialized workload.

## The trade-offs of indexes:
* Can speed up selective reads but requires extra disk space. Cab help joins, sorting and certain range 
* quearies but add extra work to inserts, updates and deletes.

## EXPLAIN VS ANALYZE EXPLAIN:
* EXPLAIN shows the estimated execution plan without running the query itself.
* ANALYZE EXPLAIN actually runs the query and reports its plan along with actual row counts and execution times.

## Why index isn't necessarily used:
* An index can exist and still be the wrong tool for a particular query.

