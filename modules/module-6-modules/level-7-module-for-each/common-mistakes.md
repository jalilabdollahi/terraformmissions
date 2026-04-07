# Common Mistakes

- **Using `[0]` index on a for_each module** — for_each uses string keys, not numeric indices.
- **Forgetting `each.key`** — inside the module block, use `each.key`/`each.value` to pass per-instance values.