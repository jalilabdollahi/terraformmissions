variable "db_password" {
  type = string
}

# Broken: plain output exposes the tfvars secret
output "db_password" {
  value = var.db_password
}
