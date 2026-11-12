# Signing keys for the Skylark delivery-drone fleet.
# Flight controllers verify telemetry with an ECDSA key on curve P-256 (NIST),
# and the ground-station firmware update channel uses a 4096-bit RSA key.

resource "tls_private_key" "telemetry" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_private_key" "firmware" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "telemetry_pub" {
  filename = "${path.module}/fleet-keys/telemetry.pub"
  content  = tls_private_key.telemetry.public_key_openssh
}

resource "local_file" "firmware_pub" {
  filename = "${path.module}/fleet-keys/firmware.pub"
  content  = tls_private_key.firmware.public_key_openssh
}

output "telemetry_algorithm" {
  value = tls_private_key.telemetry.algorithm
}
