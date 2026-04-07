# Common Mistakes

- **Not using `try()` for optional data sources** — a missing file causes the entire plan to fail.
- **Using `try()` to hide real errors** — only use it for genuinely optional values.
- **Confusing `try()` with `can()`** — `can()` returns a bool; `try()` returns the value or falls back.