resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!#$%^&*"
}

# BUG: This output exposes the raw password in plan output and CI/CD logs.
# Fix: add sensitive = true to prevent the value from appearing in output.
output "database_password" {
  value = random_password.db_password.result
}

output "password_length" {
  value = random_password.db_password.length
}
