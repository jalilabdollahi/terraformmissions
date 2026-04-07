# Common Mistakes

- **`nullable = false` with `default = null`** — the contradiction Terraform catches at validate time.
- **Forgetting that `nullable = true` is the default** — you only need to set it if you want to forbid null.