# Common Mistakes

- **Exact pinning `= X.Y.Z`** — overly strict; breaks the moment you upgrade.
- **No upper bound** — `>= 1.0` allows Terraform 2.x which may have breaking changes.
- **Forgetting to update after upgrading** — if you upgrade Terraform, bump `required_version` too.