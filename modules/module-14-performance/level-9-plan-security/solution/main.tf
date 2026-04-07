resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!#$%^&*"
}

output "database_password" {
  value     = random_password.db_password.result
  sensitive = true
}

output "password_length" {
  value = random_password.db_password.length
}
