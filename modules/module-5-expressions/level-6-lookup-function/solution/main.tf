variable "config" {
  type = map(string)
  default = {
    host = "localhost"
  }
}

locals {
  port = lookup(var.config, "port", 8080)
}

output "port" {
  value = local.port
}
