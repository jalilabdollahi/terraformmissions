variable "enabled" {
  type    = bool
  default = false
}

resource "local_file" "config" {
  count    = var.enabled ? 1 : 0
  content  = "config"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = try(local_file.config[0].filename, "")
}
