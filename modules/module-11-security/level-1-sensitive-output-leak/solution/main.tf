resource "random_password" "db" {
  length  = 16
  special = true
}

output "db_password" {
  value     = random_password.db.result
  sensitive = true
}
