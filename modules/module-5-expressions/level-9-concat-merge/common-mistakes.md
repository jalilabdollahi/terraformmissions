# Common Mistakes

- **Using `merge()` on lists** — `merge` is maps-only; use `concat` for lists.
- **Using `concat()` on maps** — `concat` is lists-only; use `merge` for maps.
- **Key collision in merge** — when maps share keys, the rightmost map wins.