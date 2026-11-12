# Scriptorium of St. Brannoc: the abbot's wax-seal key.
# The block was renamed from "seal" to "abbot_seal" so it reads better next to the
# prior's key. A moved block was added to keep the existing key... but something about
# it is off, and terraform plan refuses to run.

resource "tls_private_key" "abbot_seal" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

moved {
  from = tls_private_key.abbot_seal
  to   = tls_private_key.seal
}

resource "local_file" "seal_register" {
  filename = "${path.module}/scriptorium/seal-register.txt"
  content  = "abbot's seal fingerprint: ${tls_private_key.abbot_seal.public_key_fingerprint_sha256}\n"
}
