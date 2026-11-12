# Debrief: a certificate says what it is for

A TLS certificate is more than a name and a key: its key-usage extensions state what the key may be
used for. `tls_self_signed_cert` therefore insists on `allowed_uses`. For a web server the usual set
is `digital_signature`, `key_encipherment` and `server_auth`; client-authentication certs use
`client_auth`; a CA adds `cert_signing` together with `is_ca_certificate = true`. A client that sees
a certificate without `server_auth` may refuse it for HTTPS even if the name matches.

Two other points hide in this level. `subject` is a nested block (`subject { ... }`), not a map
attribute. Terraform uses blocks for structured repeated settings and attributes for values, and a
`=` where a block is expected produces `Unsupported argument`. And `validity_period_hours` only fixes
the lifetime from the first apply: the provider renews the certificate when `early_renewal_hours`
is reached, which makes the plan show a replacement near the expiry date.

Real-world takeaway: self-signed certificates are fine for lab, LAN and bootstrapping use, but every
client has to be told to trust them. For anything public, issue from a proper CA (ACME, a cloud
issuer) and keep the Terraform-generated key for internal tooling only.
