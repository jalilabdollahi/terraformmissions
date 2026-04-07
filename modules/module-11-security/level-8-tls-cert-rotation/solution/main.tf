resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "server" {
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Example Org"
  }

  validity_period_hours = 8760   # 1 year
  early_renewal_hours   = 168    # renew 1 week before expiry

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

output "cert_pem" {
  value     = tls_self_signed_cert.server.cert_pem
  sensitive = true
}
