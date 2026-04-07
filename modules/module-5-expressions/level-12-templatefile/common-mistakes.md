# Common Mistakes

- **Key name mismatch** — template placeholder names must exactly match the vars map keys.
- **Missing template file** — the `.tpl` path must exist at plan/apply time.
- **Using HCL syntax in templates** — templates use `${var}` syntax, not `local.x` or `var.x`.