# TLS identity for the pump controller on the Gullcove fuel dock.
resource "tls_private_key" "pump" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "pump" {
  private_key_pem = tls_private_key.pump.private_key_pem

  subject {
    common_name  = "pumps.gullcove-dock.test"
    organization = "Gullcove Marina"
  }

  dns_names = ["pumps.gullcove-dock.test"]

  validity_period_hours = 6
  early_renewal_hours   = 0
  allowed_uses          = ["digital_signature", "server_auth"]
}

resource "local_file" "pump_cert" {
  filename = "${path.module}/pki/pump.pem"
  content  = tls_self_signed_cert.pump.cert_pem
}

resource "local_sensitive_file" "pump_key" {
  filename        = "${path.module}/pki/pump.key"
  content         = tls_private_key.pump.private_key_pem
  file_permission = "0600"
}
