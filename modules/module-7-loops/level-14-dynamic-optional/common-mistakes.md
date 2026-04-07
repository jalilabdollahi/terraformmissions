# Common Mistakes

- **`nullable = false` with `default = null`** — contradictory; Terraform may error or behave unexpectedly.
- **Not understanding nullable defaults** — since Terraform 1.1, `nullable = true` is the default.