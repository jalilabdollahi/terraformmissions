# BUG: DSA is not a supported algorithm. Use RSA, ECDSA, or ED25519.

resource "tls_private_key" "server_key" {
  algorithm = "DSA"
}
