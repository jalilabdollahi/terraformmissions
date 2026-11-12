variable "lodge_name" {
  type    = string
  default = "Acacia Ridge Lodge"
}

resource "random_password" "radio_admin" {
  length      = 24
  special     = false
  min_lower   = 2
  min_upper   = 2
  min_numeric = 2
}

resource "local_sensitive_file" "radio_config" {
  filename        = "${path.module}/radio/admin.conf"
  content         = "lodge=${var.lodge_name}\nadmin_passphrase=${random_password.radio_admin.result}\n"
  file_permission = "0600"
}

output "radio_config_path" {
  value = local_sensitive_file.radio_config.filename
}
