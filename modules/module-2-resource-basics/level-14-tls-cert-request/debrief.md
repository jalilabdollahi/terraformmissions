# The Missing Subject

## What Was Broken
`tls_cert_request` requires a `subject {}` block. The subject identifies the entity for which the
certificate is being requested (the X.509 Distinguished Name).

## The Fix
```hcl
resource "tls_cert_request" "app_csr" {
  private_key_pem = tls_private_key.app.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Acme"
  }
}
```

## Subject Block Attributes

| Attribute             | Description |
|----------------------|-------------|
| `common_name`         | Domain name or hostname |
| `organization`        | Legal organization name |
| `organizational_unit` | Department name |
| `locality`            | City |
| `province`            | State or province |
| `country`             | 2-letter ISO country code |
| `postal_code`         | Postal or ZIP code |
| `serial_number`       | Certificate serial number |

## Why It Matters
Nested required blocks (as opposed to optional ones) are a common source of confusion. The resource
schema may require a block even when individual sub-arguments are optional. Always consult the
provider documentation for required nested blocks.