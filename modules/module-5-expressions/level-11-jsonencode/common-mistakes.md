# Common Mistakes

- **Using `timestamp()` in stable config** — reserve it for triggers or one-time stamps.
- **Assuming jsonencode always produces the same key order** — JSON object key order is not guaranteed.
- **Encoding sensitive values** — `jsonencode` does not redact sensitive values; use `sensitive()` wrapper if needed.