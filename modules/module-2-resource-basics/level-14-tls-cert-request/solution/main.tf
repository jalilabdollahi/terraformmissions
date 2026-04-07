resource "tls_private_key" "app" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "app_csr" {
  private_key_pem = tls_private_key.app.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Acme"
  }
}

output "csr_pem" {
  value = tls_cert_request.app_csr.cert_request_pem
}
