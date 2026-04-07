# Common Mistakes

- **Relative path confusion** — paths in `backend "local"` are relative to the Terraform working directory, not the `.tf` file location.
- **Forgetting `-reconfigure`** — when changing backends, use `terraform init -reconfigure`.
- **Using local backend in teams** — local backend has no locking; use a remote backend (S3, GCS, etc.) for shared environments.