# Common Mistakes

- **Negative validity periods** — always use a positive number of hours.
- **Very short validity in production** — use at least 8760 hours (1 year) for production certificates.
- **Forgetting `allowed_uses`** — this required attribute specifies what the certificate can be used for.
- **Using self-signed certs in public-facing production services** — they cause browser trust warnings.