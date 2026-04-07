# Common Mistakes

- **`apply_all`, `destroy`, `refresh`** — none of these are valid `command` values.
- **Omitting `command`** — perfectly fine; it defaults to `"apply"`.
- **Using `command = "plan"` then asserting applied resource attributes** — plan-time values are
  often unknown, so assertions on concrete values will fail.