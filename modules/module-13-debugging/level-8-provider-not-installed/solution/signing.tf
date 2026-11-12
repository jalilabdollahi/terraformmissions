# Dive logs are now signed by the instructor's key.

resource "tls_private_key" "logbook_signer" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "local_file" "signature_card" {
  filename = "${path.module}/divelog/signature.txt"
  content  = "Logbook signer: ${tls_private_key.logbook_signer.public_key_fingerprint_sha256}\n"
}

output "signing_fingerprint" {
  value = tls_private_key.logbook_signer.public_key_fingerprint_sha256
}
