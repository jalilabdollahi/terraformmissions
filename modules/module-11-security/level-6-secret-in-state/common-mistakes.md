# Common Mistakes

- **Using `local_file` for any secret** — always use `local_sensitive_file` for credentials.
- **Setting `file_permission = "0644"` on `local_sensitive_file`** — this overrides the default
  strict permissions and defeats the purpose.
- **Thinking file permissions protect secrets in a Docker container** — in containers, use
  environment variables or secrets managers instead of files.