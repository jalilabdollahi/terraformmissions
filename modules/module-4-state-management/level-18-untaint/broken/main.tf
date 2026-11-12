# Brightwave Firmware: release signing.
# The public half of the signing key is burned into every device bootloader.

resource "tls_private_key" "firmware_signer" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "local_file" "bootloader_pubkey" {
  filename = "${path.module}/release/signer.pub"
  content  = tls_private_key.firmware_signer.public_key_openssh
}
