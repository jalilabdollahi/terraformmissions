resource "random_password" "db" {
  length  = 16
  special = true
}

# Broken: exposes the password in plain output
output "db_password" {
  value = random_password.db.result
}
