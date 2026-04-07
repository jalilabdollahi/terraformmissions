resource "tls_private_key" "server_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
