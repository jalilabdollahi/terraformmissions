# Common Mistakes

- **Using `nonsensitive()` on actual secrets** — only the keys need to be non-sensitive.
- **Marking entire maps as sensitive when only values are sensitive** — use `sensitive()` on individual outputs instead.
- **Confusing `sensitive = true` on variables with attribute-level sensitivity** — they behave differently.