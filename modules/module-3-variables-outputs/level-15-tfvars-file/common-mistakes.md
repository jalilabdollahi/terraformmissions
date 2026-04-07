# Common Mistakes

- **Missing `=` in tfvars** — every assignment needs `key = value`.
- **Forgetting quotes for string values** — `environment = production` (unquoted) is invalid.
- **Using HCL block syntax in tfvars** — you cannot use `resource`, `variable`, etc. in `.tfvars` files.