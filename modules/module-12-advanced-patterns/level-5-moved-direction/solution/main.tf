# Hollis & Daughter Locksmiths: the master key for the shop's safe.
# The block was renamed from "master" to "master_key" so it reads better next to the
# shop's other keys. A moved block was added to keep the existing key... but something about
# it is off, and terraform plan refuses to run.

resource "tls_private_key" "master_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

moved {
  from = tls_private_key.master
  to   = tls_private_key.master_key
}

resource "local_file" "key_register" {
  filename = "${path.module}/keyshop/key-register.txt"
  content  = "master key fingerprint: ${tls_private_key.master_key.public_key_fingerprint_sha256}\n"
}
