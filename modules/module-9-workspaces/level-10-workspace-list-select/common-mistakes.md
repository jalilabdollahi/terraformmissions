# Common Mistakes

- **No default on required variables** — always provide defaults for variables used in automated workflows.
- **Using a variable instead of `terraform.workspace`** — prefer the built-in directly; it is always available and always correct.
- **Not cleaning up test workspaces** — workspaces accumulate; delete them when done with `terraform workspace delete`.