# Positive tests
## Valid records can be inserted and relationships can be created normally.


# Negative tests
## Missing required values, duplicate identifiers and invalid references are rejected.


# Boundary tests
## Values at and around a rule's limits behave correctly—for example, zero quantity should fail while quantity one should succeed.


# Relationship tests
## Foreign keys, unique combinations and parent-child relationships remain valid.


# Repeatability
## Tests can be rerun without leaving test records behind or corrupting the normal development database.