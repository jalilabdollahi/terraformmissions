variable "config" {
  type = map(string)
  default = {
    host = "localhost"
  }
}

# BUG: lookup() requires a default value as the third argument
locals {
  port = lookup(var.config, "port")
}

output "port" {
  value = local.port
}
