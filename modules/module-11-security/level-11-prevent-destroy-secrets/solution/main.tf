# The deed box at Ashgrove & Pell, notaries. The master passphrase seals the digital
# deed register; losing it means the register can never be opened again.
resource "random_password" "box_master" {
  length  = 32
  special = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "local_sensitive_file" "deed_register" {
  filename        = "${path.module}/register/deed-box.key"
  content         = "${random_password.box_master.result}\n"
  file_permission = "0600"

  lifecycle {
    prevent_destroy = true
  }
}

output "register_file" {
  value = local_sensitive_file.deed_register.filename
}
