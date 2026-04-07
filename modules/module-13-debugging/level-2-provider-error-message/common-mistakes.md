# Common Mistakes

- **Using a number instead of a string** — `644` vs `"0644"`.
- **Forgetting the leading `0`** — `"644"` is parsed differently from `"0644"` (decimal vs octal notation).
- **Using `"0644"` when `"0600"` is needed for secrets** — always use the most restrictive permissions that work.