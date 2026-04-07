variable "db_password" {
  type      = string
  sensitive = true
  default   = "super-secret"
}

locals {
  # Sensitivity propagates automatically from var.db_password to local.password
  password = var.db_password
}

# Broken: nonsensitive() strips the sensitivity — the value will be exposed in output
output "password" {
  value = nonsensitive(local.password)
}
