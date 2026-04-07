# Common Mistakes

- **Using variables in backend blocks** — not supported; use `-backend-config` for dynamic values.
- **Using locals in backend blocks** — also not supported for the same reason.
- **Forgetting `-reconfigure`** — when you change the backend, run `terraform init -reconfigure`.