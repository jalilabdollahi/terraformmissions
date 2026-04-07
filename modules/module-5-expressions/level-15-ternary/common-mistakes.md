# Common Mistakes

- **Mixed types in branches** — string vs number, list vs map — all cause type errors.
- **Nested ternaries** — hard to read; prefer `if/else` with locals or a map lookup.
- **Using non-bool conditions** — the condition must be a bool; use `tobool()` or comparison operators.