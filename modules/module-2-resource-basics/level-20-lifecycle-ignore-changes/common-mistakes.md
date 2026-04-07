# Common Mistakes

- **Typos in attribute names inside `ignore_changes`** — all names are validated against the schema.
- **Using `ignore_changes = all` as a habit** — it creates drift between your config and the actual infrastructure state.
- **Ignoring required attributes** — if you ignore `filename`, tracking the file path becomes unreliable.
- **Confusing `ignore_changes` with `prevent_destroy`** — they serve entirely different purposes.