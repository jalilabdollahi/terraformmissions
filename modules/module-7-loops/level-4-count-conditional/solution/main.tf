variable "enabled" {
  type    = bool
  default = true
}

resource "local_file" "config" {
  count    = var.enabled ? 1 : 0
  content  = "enabled config"
  filename = "${path.module}/config.txt"
}
