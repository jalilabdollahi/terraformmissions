variable "enabled" {
  type    = bool
  default = false
}

resource "local_file" "config" {
  count    = var.enabled ? 1 : 0
  content  = "config"
  filename = "${path.module}/config.txt"
}

# This will error when count = 0 (enabled = false)
output "config_path" {
  value = local_file.config[0].filename
}
