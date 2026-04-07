# Common Mistakes

- **Using `local_file` for secrets** — it writes world-readable files.
- **Forgetting `sensitive = true` on outputs** — the value appears in `terraform output` and apply logs.
- **Thinking state encryption is automatic** — it requires backend configuration.