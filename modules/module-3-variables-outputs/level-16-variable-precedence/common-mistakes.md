# Common Mistakes

- **Wrong type declaration blocking string inputs** — use `type = string` for name/environment variables.
- **Forgetting variable precedence order** — `-var` flags override tfvars, which override defaults.
- **Not testing with `-var` flags** — always verify that your module accepts the values callers will pass.