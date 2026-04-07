# Common Mistakes

- **Typos in `terraform.workspace`** — it is easy to transpose letters; validate catches this immediately.
- **Using `workspace` alone** — `workspace` is not a standalone variable; always use the full `terraform.workspace`.
- **Hardcoding workspace names** — environments change; prefer maps or conditionals over hardcoded strings.