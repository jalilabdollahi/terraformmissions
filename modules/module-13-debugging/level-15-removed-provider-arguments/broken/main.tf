# Cobalt Canal Authority - lock-gate controller identity (written for tls provider 3.x).

resource "tls_private_key" "gate" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "gate" {
  private_key_pem = tls_private_key.gate.private_key_pem
  key_algorithm   = tls_private_key.gate.algorithm

  subject {
    common_name  = "gate-4.cobalt-canal.example"
    organization = "Cobalt Canal Authority"
  }
}

resource "tls_self_signed_cert" "gate" {
  private_key_pem = tls_private_key.gate.private_key_pem
  key_algorithm   = tls_private_key.gate.algorithm

  validity_period_hours = 720
  allowed_uses          = ["digital_signature", "server_auth"]

  subject {
    common_name  = "gate-4.cobalt-canal.example"
    organization = "Cobalt Canal Authority"
  }
}

resource "local_file" "gate_cert" {
  filename = "${path.module}/gate/gate-4.crt"
  content  = tls_self_signed_cert.gate.cert_pem
}

resource "local_file" "gate_csr" {
  filename = "${path.module}/gate/gate-4.csr"
  content  = tls_cert_request.gate.cert_request_pem
}

output "gate_key_algorithm" {
  value = tls_private_key.gate.algorithm
}
