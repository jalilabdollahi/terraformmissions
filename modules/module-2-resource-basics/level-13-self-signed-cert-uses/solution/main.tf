# Self-signed TLS cert for the Nightfall Arena LAN-party scoreboard server.
# Browsers on the LAN party network are told to trust this certificate for
# the server's name; it must be usable as a TLS server certificate.

resource "tls_private_key" "scoreboard" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "scoreboard" {
  private_key_pem       = tls_private_key.scoreboard.private_key_pem
  validity_period_hours = 72
  dns_names             = ["scoreboard.arena.lan"]

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
  ]

  subject {
    common_name  = "scoreboard.arena.lan"
    organization = "Nightfall Arena"
  }
}

resource "local_file" "scoreboard_cert" {
  filename = "${path.module}/pki/scoreboard.pem"
  content  = tls_self_signed_cert.scoreboard.cert_pem
}

output "cert_valid_until" {
  value = tls_self_signed_cert.scoreboard.validity_end_time
}
