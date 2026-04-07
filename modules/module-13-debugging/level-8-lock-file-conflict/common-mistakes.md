# Common Mistakes

- **Manually editing the lock file** — the result is almost always a hash mismatch.
- **Checking in a corrupted lock file** — CI will fail for all team members.
- **Using `terraform init -upgrade` unnecessarily** — only use `-upgrade` when you actually want to update provider versions.