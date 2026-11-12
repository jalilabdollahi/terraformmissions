# Ironvale Dam Authority - spillway gate controller identity.

resource "tls_private_key" "spillway" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "spillway" {
  private_key_pem = tls_private_key.spillway.private_key_pem

  subject {
    common_name  = "spillway-4.ironvale-dam.example"
    organization = "Ironvale Dam Authority"
  }
}

resource "tls_self_signed_cert" "spillway" {
  private_key_pem = tls_private_key.spillway.private_key_pem

  validity_period_hours = 720
  allowed_uses          = ["digital_signature", "server_auth"]

  subject {
    common_name  = "spillway-4.ironvale-dam.example"
    organization = "Ironvale Dam Authority"
  }
}

resource "local_file" "spillway_cert" {
  filename = "${path.module}/spillway/spillway-4.crt"
  content  = tls_self_signed_cert.spillway.cert_pem
}

resource "local_file" "spillway_csr" {
  filename = "${path.module}/spillway/spillway-4.csr"
  content  = tls_cert_request.spillway.cert_request_pem
}

output "spillway_key_algorithm" {
  value = tls_private_key.spillway.algorithm
}
