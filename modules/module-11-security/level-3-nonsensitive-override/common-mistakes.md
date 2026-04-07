# Common Mistakes

- **Using `nonsensitive()` to silence "output refers to sensitive values" errors** — the right
  fix is `sensitive = true` on the output, not `nonsensitive()` on the value.
- **Applying `nonsensitive()` to objects that still contain secret fields**.
- **Forgetting that `nonsensitive()` is permanent for that reference** — once stripped, any
  module receiving the output sees it as non-sensitive.