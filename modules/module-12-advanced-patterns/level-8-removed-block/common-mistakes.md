# Common Mistakes

- **Leaving the resource block in config** — the resource must be removed before `removed` can work.
- **Using `removed` on Terraform < 1.7** — this feature was introduced in Terraform 1.7.
- **Setting `destroy = true` unintentionally** — `destroy = false` preserves the real resource; `destroy = true` destroys it.