# CTEs, Subqueries, and Window Functions

Use the smallest SQL tool that clearly expresses the question. These
constructs shape a query; they do not change the relational model.

| Question | Useful tool | Example in this project |
| --- | --- | --- |
| Name stages in a multi-step query | CTE (`WITH`) | Order totals |
| Compare a value with an aggregate | Scalar subquery | Products above average price |
| Test whether related rows exist | `EXISTS` / `NOT EXISTS` | Customers with orders |
| Select the latest row per group | `ROW_NUMBER()` | Latest order per customer |
| Rank rows while preserving ties | `RANK()` / `DENSE_RANK()` | Product sales ranking |
| Calculate a running value | `SUM() OVER (...)` | Cumulative order value |
| Compare with the preceding row | `LAG()` | Change from the previous order |

Runnable examples are in `sql/queries/004_ctes_subqueries_windows.sql`.

Window functions retain individual rows, unlike `GROUP BY`, which combines
rows. Use a deterministic tie-breaker such as a primary key in the window's
`ORDER BY` so equal timestamps do not make the result ambiguous.