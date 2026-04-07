# Common Mistakes

- **`prevent_destroy = true` in shared modules** — child modules should let callers control
  this via a variable.
- **Relying solely on `prevent_destroy` for production safety** — combine with IAM policies,
  state locking, and change approval workflows.
- **`prevent_destroy = var.environment == "prod"`** — be careful with typos in the workspace
  or environment name; use `contains(["production", "prod"], terraform.workspace)` for flexibility.