# Common Mistakes

- **String-to-number comparison** — always convert first with `tonumber()`.
- **Forgetting that JSON numbers become strings** — when reading from data sources or variables, numbers may arrive as strings.
- **`tonumber()` on non-numeric strings** — `tonumber("abc")` errors; use `try(tonumber(x), 0)` for safe conversion.