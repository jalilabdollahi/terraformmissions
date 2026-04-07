# Common Mistakes

- **Hardcoding algorithm strings** — use resource attribute references so changes propagate.
- **Forgetting `is_ca_certificate = true` on the CA cert** — without it, the cert cannot sign.
- **Using too-short validity periods** — short-lived certs require frequent rotation automation.