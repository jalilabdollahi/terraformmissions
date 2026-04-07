# Common Mistakes

- **Typos in shell commands** — validate commands manually before embedding them in provisioners.
- **Forgetting that `local-exec` runs on the Terraform host** — not on the resource being created.
- **Not handling non-zero exit codes** — use `|| true` to ignore failures only when explicitly acceptable.
- **Relying on provisioners for idempotency** — provisioners do not re-run unless the resource is tainted or triggers change.