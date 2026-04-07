# Common Mistakes

- **Hardcoding workspace names in paths** — always use `terraform.workspace` for workspace-specific paths.
- **Missing `depends_on`** — implicit file dependencies need explicit ordering.
- **Assuming the default workspace** — code should work correctly in all workspaces, not just `default`.