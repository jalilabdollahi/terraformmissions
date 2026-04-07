# Common Mistakes

- **Using `index()` as a membership check** — prefer `contains()` for safety.
- **0-based vs 1-based confusion** — `index()` returns 0 for the first element, not 1.
- **Using `contains()` on maps** — `contains()` only works on lists/sets; use `lookup()` for maps.