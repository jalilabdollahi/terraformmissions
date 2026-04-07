# Common Mistakes

- **Default values that fail their own preconditions** — always test the default against all conditions.
- **Confusing `precondition` with `postcondition`** — `precondition` checks inputs before evaluation; `postcondition` checks the output value after.
- **Using preconditions for simple single-variable checks** — prefer `variable.validation` for those; preconditions shine for cross-variable assertions.