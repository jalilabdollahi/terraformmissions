# Common Mistakes

- **Hardcoding key access on potentially empty maps** — always guard or ensure the key exists.
- **Expecting `{}` to error** — empty `for_each` is valid and creates nothing silently.