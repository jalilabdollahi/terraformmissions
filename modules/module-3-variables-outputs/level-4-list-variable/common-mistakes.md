# Common Mistakes

- **Mixing types in `list(string)`** — every element must be a string.
- **Forgetting that numeric-looking values need quotes** — `3` ≠ `"3"` in HCL.
- **Using `list` without a type parameter** — `list` alone is deprecated; prefer `list(string)`, `list(number)`, etc.