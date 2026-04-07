variable "db_password" {
  type      = string
  sensitive = true
}

output "db_password" {
  value     = var.db_password
  sensitive = true
}
