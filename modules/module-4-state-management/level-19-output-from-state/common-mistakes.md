# Common Mistakes

- **Wrong backend type** — the backend in `terraform_remote_state` must match where state is actually stored.
- **Missing outputs** — the remote state must have explicit `output` blocks; resource attributes are not automatically accessible.
- **Path or key mismatch** — for S3/GCS backends, verify the exact key path matches the source state file.