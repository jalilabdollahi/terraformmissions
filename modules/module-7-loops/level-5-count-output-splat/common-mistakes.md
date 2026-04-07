# Common Mistakes

- **Omitting `[*]`** — a count resource is a collection, not a single object.
- **Using `[*]` on a non-count resource** — this always returns a list with 0 or 1 elements, which is usually not what you want.