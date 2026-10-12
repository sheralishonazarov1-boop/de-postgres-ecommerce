# Constraint and Data Quality Tests

## Positive Tests

Valid records can be inserted and their relationships created normally.

## Negative Tests

Missing required values, duplicate identifiers, unsupported order statuses,
and invalid references are rejected.

## Boundary Tests

Values at and around a rule's limits behave correctly. For example, zero
quantity should fail while quantity one should succeed.

## Relationship Tests

Foreign keys and parent-child relationships remain valid.

## Repeatability

Tests can be rerun without leaving test records behind or corrupting the
normal development database.