# Common Mistakes

- **Using `-refresh-only` to fix drift** — it updates the state to match reality, but does not fix the actual resource.
- **Forgetting `depends_on`** — a data source reading a resource-created file needs explicit ordering.
- **Base64 confusion** — `content_base64` looks like a long random string; if your output looks garbled, switch to `content`.