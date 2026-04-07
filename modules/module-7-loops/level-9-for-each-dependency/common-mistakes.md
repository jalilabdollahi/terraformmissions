# Common Mistakes

- **Passing `resource.name` directly** — always convert to map/set explicitly.
- **`each.value.filename` vs `each.value`** — after converting to a map of filenames, `each.value` IS the filename string.