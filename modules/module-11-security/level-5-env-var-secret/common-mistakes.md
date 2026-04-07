# Common Mistakes

- **Uppercase variable names** — use `snake_case` for all Terraform identifiers.
- **Relying on `TF_VAR_DB_PASSWORD` matching `var.db_password`** — casing must match exactly.
- **Setting `TF_VAR_` but forgetting `sensitive = true`** — the variable is still exposed in
  plan/apply output without the sensitive flag.