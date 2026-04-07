variable "enabled" {
  type    = string
  default = "true"
}

# String can't be used directly in a ternary condition as a bool
resource "local_file" "config" {
  count    = var.enabled ? 1 : 0
  content  = "enabled config"
  filename = "${path.module}/config.txt"
}
