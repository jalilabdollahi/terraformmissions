# Common Mistakes

- **`nullable = false` with `default = null`** — these are contradictory.
- **Confusing `nullable = false` semantics** — it doesn't prevent the variable from having a default; it prevents the value from ever being null.
- **Omitting `nullable` entirely** — `nullable = true` is the default; add `nullable = false` only when you need the override-null-with-default behavior.