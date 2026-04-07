# Common Mistakes

- **Accessing nonexistent map keys** — use `lookup(map, key, default)` for safe access.
- **length() on null** — calling `length(null)` causes an error; use `var != null ? length(var) : 0`.
- **Counting map values vs keys** — `length(map)` counts keys; to count values, use `length(values(map))`.