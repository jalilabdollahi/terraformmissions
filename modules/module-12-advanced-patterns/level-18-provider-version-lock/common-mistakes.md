# Common Mistakes

- **Manually editing the lock file** — always let `terraform init` manage it.
- **Committing a platform-specific lock file** — use `terraform providers lock` to add multiple platform hashes.
- **Ignoring hash mismatch errors** — they indicate either corruption or a supply chain issue.