# Common Mistakes

- **Comma instead of `=>`** — always use `key => value` in map-producing expressions.
- **Duplicate keys** — if the key expression produces duplicates, Terraform errors; use `...` grouping mode to collect into lists.
- **Using list syntax for maps** — `[for k, v in map : k]` produces a list of keys, not a map.