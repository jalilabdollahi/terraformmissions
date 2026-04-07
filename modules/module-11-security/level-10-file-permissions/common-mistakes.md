# Common Mistakes

- **`"777"` or `"666"` for secrets** — world-readable; never acceptable for credentials.
- **Omitting the leading zero** — `"600"` is decimal six hundred, not octal 0600. Use `"0600"`.
- **Using `"0600"` on files that daemons need to read** — if a non-owner process reads the
  file, use `"0640"` (group read) with appropriate group ownership.