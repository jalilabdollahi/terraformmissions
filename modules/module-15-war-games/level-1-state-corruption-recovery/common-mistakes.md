# Common Mistakes

- **Using local state backend in production** — local state has no versioning, no locking, no backup.
- **Not checking for .backup file first** — Terraform's backup is often intact even when primary is corrupt.
- **Deleting state without importing** — after clean apply, manually imported resources may be missing.
- **Not enabling state locking** — concurrent applies without locking cause corruption and race conditions.
- **Ignoring write errors during apply** — if apply exits uncleanly, always verify state integrity before next run.