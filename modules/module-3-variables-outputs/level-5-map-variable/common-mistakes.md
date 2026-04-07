# Common Mistakes

- **Mixing types in `map(string)`** — every value must be a string.
- **Using `map` without a type parameter** — `map` alone is deprecated; use `map(string)`, `map(number)`, etc.
- **Confusing `map(string)` with `object({...})`** — use `object` when keys have different types.