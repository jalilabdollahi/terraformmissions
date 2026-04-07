# Common Mistakes

- **Omitting the `subject {}` block entirely** — it is required for `tls_cert_request`.
- **Confusing `tls_cert_request` with `tls_self_signed_cert`** — a CSR is submitted to an external CA; a self-signed cert is both CA and certificate.
- **Not including SANs for production use** — production TLS certificates typically need Subject Alternative Names via `dns_names` or `ip_addresses`.