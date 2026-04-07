# Common Mistakes

- **Typos in attribute names** — use the exact key names from the `object({...})` declaration.
- **Expecting dot-access to work on `map(string)`** — maps use bracket access: `var.tags["key"]` or `var.tags.key`.
- **Not using `try()` for optional keys** — if a key is `optional()`, it may be absent; use `try()` for safe access.