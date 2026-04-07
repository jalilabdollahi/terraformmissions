# Common Mistakes

- **Using `nonsensitive()` to "fix" a validate error** — if Terraform complains about a sensitive
  value, the correct fix is usually to mark the output `sensitive = true`, not to call `nonsensitive()`.
- **Forgetting locals propagate sensitivity** — you do not need to annotate locals; it is automatic.
- **Using `nonsensitive()` on a whole object containing secrets** — this exposes every field.