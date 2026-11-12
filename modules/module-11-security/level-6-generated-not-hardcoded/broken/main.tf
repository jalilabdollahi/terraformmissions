variable "lodge_name" {
  type    = string
  default = "Acacia Ridge Lodge"
}

locals {
  radio_admin_password = "demo-not-a-real-secret-safari-1"
}

resource "local_sensitive_file" "radio_config" {
  filename        = "${path.module}/radio/admin.conf"
  content         = "lodge=${var.lodge_name}\nadmin_passphrase=${local.radio_admin_password}\n"
  file_permission = "0600"
}

output "radio_config_path" {
  value = local_sensitive_file.radio_config.filename
}
