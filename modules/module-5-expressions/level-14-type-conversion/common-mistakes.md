# Common Mistakes

- **`tolist()` on maps** — not supported; use `values()` or `keys()`.
- **Assuming map value order** — `values()` returns values in lexicographic key order in Terraform 0.15+.
- **`toset()` vs `tolist()`** — `toset` removes duplicates and has no order; `tolist` preserves order.