# Common Mistakes

- **Silent typos in conditionals** — the plan succeeds with wrong logic; always test workspace-based branching.
- **Case sensitivity** — `"Production"` != `"production"`.
- **Hardcoding workspace names** — consider extracting workspace names into a `locals` or `variable` block for reuse.