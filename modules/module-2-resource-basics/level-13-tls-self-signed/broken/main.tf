resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# BUG: validity_period_hours = -1 is invalid; must be a positive number.
resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Acme Corp"
  }

  validity_period_hours = -1

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}
