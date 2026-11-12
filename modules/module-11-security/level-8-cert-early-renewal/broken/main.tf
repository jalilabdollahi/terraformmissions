# TLS identity for the charger controller at the Kestrel Junction EV charging hub.
resource "tls_private_key" "charger" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "charger" {
  private_key_pem = tls_private_key.charger.private_key_pem

  subject {
    common_name  = "chargers.kestrel-hub.test"
    organization = "Kestrel Junction Charging"
  }

  dns_names = ["chargers.kestrel-hub.test"]

  validity_period_hours = 6
  early_renewal_hours   = 0
  allowed_uses          = ["digital_signature", "server_auth"]
}

resource "local_file" "charger_cert" {
  filename = "${path.module}/pki/charger.pem"
  content  = tls_self_signed_cert.charger.cert_pem
}

resource "local_sensitive_file" "charger_key" {
  filename        = "${path.module}/pki/charger.key"
  content         = tls_private_key.charger.private_key_pem
  file_permission = "0600"
}
