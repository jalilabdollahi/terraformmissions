# Common Mistakes

- **`locals.` instead of `local.`** — the reference prefix is always `local.` (singular).
- **Missing workspace key in map** — if the current workspace is not in the map, Terraform raises a key-not-found error at plan time.
- **Not using `try()` for optional keys** — wrap with `try(local.map[terraform.workspace], "default")` for safety.