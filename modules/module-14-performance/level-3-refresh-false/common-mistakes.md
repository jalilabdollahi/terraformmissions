# Common Mistakes

- **Using ignore_changes = all permanently** — creates "zombie" resources that drift silently.
- **Using -refresh=false as the default** — leads to stale state diverging from reality undetected.
- **Not documenting why ignore_changes is used** — always add a comment explaining the justification.
- **Confusing -refresh=false with -refresh-only** — these are completely different operations.