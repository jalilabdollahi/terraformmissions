# Common Mistakes

- **Writing a condition that rejects the default value** — always test your condition against the default.
- **Using `==` when multiple values are valid** — use `contains()` for enum-style validation.
- **Overly strict conditions** — consider which environments/values are legitimately valid.