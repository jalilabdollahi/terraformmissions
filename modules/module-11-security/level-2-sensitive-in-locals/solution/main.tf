variable "db_password" {
  type      = string
  sensitive = true
  default   = "super-secret"
}

locals {
  password = var.db_password
}

output "password" {
  value     = local.password
  sensitive = true
}
