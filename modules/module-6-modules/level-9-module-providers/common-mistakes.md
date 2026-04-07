# Common Mistakes

- **Using the alias name as a string** — `local = "primary"` is wrong; use `local = local.primary` (no quotes).
- **Forgetting to declare the alias** — the `provider` block with `alias` must exist in the root.