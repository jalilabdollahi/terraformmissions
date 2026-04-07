# Common Mistakes

- **Wrapping too much in `try()`** — only guard the specific attribute that might be missing.
- **Ignoring the error** — if a data source consistently fails, investigate the root cause rather than always falling back.
- **Using `try()` on required values** — do not use `try()` to mask errors on configuration that should always be present.
- **Confusing `try()` with `can()`** — `try()` returns a value; `can()` returns a boolean.