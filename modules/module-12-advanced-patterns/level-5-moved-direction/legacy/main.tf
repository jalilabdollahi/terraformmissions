resource "tls_private_key" "master" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "local_file" "key_register" {
  filename = "${path.module}/keyshop/key-register.txt"
  content  = "master key fingerprint: ${tls_private_key.master.public_key_fingerprint_sha256}\n"
}
