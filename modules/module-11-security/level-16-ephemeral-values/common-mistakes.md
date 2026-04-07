# Common Mistakes

- **Protecting the variable but not the output** — both must be marked sensitive.
- **Using `local_file` for any secret** — always use `local_sensitive_file`.
- **Assuming `sensitive = true` on the variable automatically protects all downstream uses** —
  each output and file must be explicitly protected.