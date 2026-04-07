# Common Mistakes

- **Separator mismatch** — the separator in `split()` must match the actual delimiter in the string.
- **Assuming trim** — `split` does not trim whitespace from elements; use `trimspace()` if needed.
- **Using split on empty string** — `split(",", "")` returns `[""]` (a list with one empty string), not `[]`.