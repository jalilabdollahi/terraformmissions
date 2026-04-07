# Common Mistakes

- **`nonsensitive(resource.attr)` to silence errors** — solve the root cause instead.
- **Forgetting to update references after changing `local_file` to `local_sensitive_file`** —
  the output references `local_file.db_password.filename`; update it to
  `local_sensitive_file.db_password.filename`.
- **Applying `nonsensitive()` to derived values containing the secret** — interpolations like
  `"prefix-${nonsensitive(var.secret)}-suffix"` still expose the raw secret.