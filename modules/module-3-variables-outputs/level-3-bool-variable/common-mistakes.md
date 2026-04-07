# Common Mistakes

- **Quoting booleans** — `"true"` and `"false"` are strings, not booleans.
- **Using `0`/`1` for booleans** — HCL booleans are `true`/`false`, not integers.
- **Forgetting that `"false"` may behave as truthy in other contexts** — always use the correct type.