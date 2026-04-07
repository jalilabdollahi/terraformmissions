# Common Mistakes

- **Typos in output names** — output names are case-sensitive.
- **Output not declared in source** — the source stack must have an `output` block; resources are not automatically accessible.
- **Stale state** — if the source stack was updated, you need to re-plan the consumer to pick up new outputs.