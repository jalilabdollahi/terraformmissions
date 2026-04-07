# Common Mistakes

- **Using `tomap()` on lists** — maps require keys; lists don't have them.
- **Unnecessary type conversions** — `tolist(["a","b"])` is the same as `["a","b"]` in most contexts.
- **Confusing `tomap()` with `zipmap()`** — use `zipmap(keys, values)` to build a map from two lists.