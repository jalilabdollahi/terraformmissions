# SFTP identity for the Marrowby bookmobile's nightly catalogue sync.
resource "tls_private_key" "bookmobile" {
  algorithm = "ED25519"
}

resource "local_file" "private_key" {
  filename        = "${path.module}/keys/bookmobile_ed25519"
  content         = tls_private_key.bookmobile.private_key_openssh
  file_permission = "0644"
}

resource "local_file" "public_key" {
  filename        = "${path.module}/keys/bookmobile_ed25519.pub"
  content         = tls_private_key.bookmobile.public_key_openssh
  file_permission = "0644"
}

output "public_key" {
  value = trimspace(tls_private_key.bookmobile.public_key_openssh)
}
