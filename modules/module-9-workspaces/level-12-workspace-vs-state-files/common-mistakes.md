# Common Mistakes

- **Interpolation in backend** — this is a very common mistake; always use static strings in backend blocks.
- **Manually managing workspace paths** — Terraform handles workspace state separation; don't fight it.
- **Using workspaces for fundamentally different environments** — if `staging` and `production` have different providers or accounts, use separate root modules instead.
- **Forgetting `-reconfigure` after fixing backend** — after fixing the backend block, run `terraform init -reconfigure` to reinitialise.