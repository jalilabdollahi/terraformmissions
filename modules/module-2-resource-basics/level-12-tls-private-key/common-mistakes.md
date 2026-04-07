# Common Mistakes

- **Using `DSA` or `RSA-PSS`** — only RSA, ECDSA, and ED25519 are supported.
- **Not setting `rsa_bits` for RSA** — defaults to 2048; consider 4096 for long-lived certificates.
- **Storing private keys in outputs without `sensitive = true`** — private keys must be kept secret.