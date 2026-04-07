# Common Mistakes

- **Passing via `var.` prefix** — `app_name = var.app_name` is valid only if the root also has a variable; for a literal, just use the string directly.
- **Wrong argument name** — the argument name in the module call must exactly match the variable name in the child.