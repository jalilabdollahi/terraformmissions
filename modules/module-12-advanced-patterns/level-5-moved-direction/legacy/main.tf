resource "tls_private_key" "seal" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "local_file" "seal_register" {
  filename = "${path.module}/scriptorium/seal-register.txt"
  content  = "abbot's seal fingerprint: ${tls_private_key.seal.public_key_fingerprint_sha256}\n"
}
