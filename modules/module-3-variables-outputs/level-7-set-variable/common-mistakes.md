# Common Mistakes

- **Using `set` when order matters** — sets are unordered; use `list` if order is important.
- **Accidentally including duplicates** — review all elements when declaring a set default.
- **Forgetting `toset()` when using a `list` with `for_each`** — `for_each` requires a set or map.