# Wrong ca_key_algorithm in TLS Cert Chain

## What Was Broken
`ca_key_algorithm = "RSA"` was hardcoded. While this happened to match the CA key, hardcoded
values create fragile configurations: if the CA key algorithm is changed to `ECDSA`, the
`tls_locally_signed_cert` resource would silently use the wrong algorithm.

## Dynamic Reference Pattern
```hcl
resource "tls_locally_signed_cert" "server" {
  ca_key_algorithm = tls_private_key.ca.algorithm  # always in sync with the CA key
  ...
}
```

## TLS Certificate Chain Components
1. `tls_private_key.ca` — CA private key
2. `tls_self_signed_cert.ca` — CA certificate (self-signed)
3. `tls_private_key.server` — server private key
4. `tls_cert_request.server` — certificate signing request (CSR)
5. `tls_locally_signed_cert.server` — server cert signed by the CA

## Why It Matters
Certificate chain errors cause TLS handshake failures that are notoriously difficult to debug.
Referencing resources dynamically ensures all parts of the chain stay consistent.