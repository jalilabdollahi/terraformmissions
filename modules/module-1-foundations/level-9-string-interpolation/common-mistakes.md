# Common Mistakes

- **`$(...)` instead of `${...}`** — common for developers coming from bash.
- **Forgetting `var.` prefix** — `${environment}` is invalid; use `${var.environment}`.
- **Over-interpolating** — `"${var.x}"` can be simplified to `var.x` when the entire value is the variable.