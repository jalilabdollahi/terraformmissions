# Common Mistakes

- **Hardcoding `[0]` without guarding** — always check or use `try()` when count might be 0.
- **Using `count = 0` to delete resources** — this works, but is sometimes surprising when outputs break.