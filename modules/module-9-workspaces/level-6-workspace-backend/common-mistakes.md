# Common Mistakes

- **Interpolation in backend** — backend blocks are static; use `-backend-config` for dynamic values.
- **Manually naming per-workspace paths** — Terraform handles workspace state isolation automatically.
- **Confusing local backend path with workspace state path** — the `path` is the base; workspaces create subdirectories automatically.