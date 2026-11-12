variable "tower_name" {
  type    = string
  default = "Pine Ridge Lookout"
}

locals {
  radio_admin_password = "demo-not-a-real-secret-lookout-1"
}

resource "local_sensitive_file" "radio_config" {
  filename        = "${path.module}/radio/admin.conf"
  content         = "tower=${var.tower_name}\nadmin_passphrase=${local.radio_admin_password}\n"
  file_permission = "0600"
}

output "radio_config_path" {
  value = local_sensitive_file.radio_config.filename
}
