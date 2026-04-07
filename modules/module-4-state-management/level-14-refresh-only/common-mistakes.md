# Common Mistakes

- **Using deprecated attributes** — always check current provider docs for exported attribute names.
- **Confusing `-refresh-only` with `terraform refresh`** — `terraform refresh` is deprecated; use `-refresh-only` flag.
- **Applying refresh-only when you meant a full apply** — refresh-only never creates/modifies/destroys resources.