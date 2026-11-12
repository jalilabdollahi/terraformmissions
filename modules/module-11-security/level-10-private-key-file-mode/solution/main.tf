# SFTP identity for the Marrowby chimney sweep round's nightly job-sheet sync.
resource "tls_private_key" "sweepround" {
  algorithm = "ED25519"
}

resource "local_sensitive_file" "private_key" {
  filename             = "${path.module}/keys/sweepround_ed25519"
  content              = tls_private_key.sweepround.private_key_openssh
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "local_file" "public_key" {
  filename        = "${path.module}/keys/sweepround_ed25519.pub"
  content         = tls_private_key.sweepround.public_key_openssh
  file_permission = "0644"
  directory_permission = "0700"
}

output "public_key" {
  value = trimspace(tls_private_key.sweepround.public_key_openssh)
}
