# SFTP identity for the Marrowby milk round's nightly delivery-sheet sync.
resource "tls_private_key" "milkround" {
  algorithm = "ED25519"
}

resource "local_file" "private_key" {
  filename        = "${path.module}/keys/milkround_ed25519"
  content         = tls_private_key.milkround.private_key_openssh
  file_permission = "0644"
}

resource "local_file" "public_key" {
  filename        = "${path.module}/keys/milkround_ed25519.pub"
  content         = tls_private_key.milkround.public_key_openssh
  file_permission = "0644"
}

output "public_key" {
  value = trimspace(tls_private_key.milkround.public_key_openssh)
}
