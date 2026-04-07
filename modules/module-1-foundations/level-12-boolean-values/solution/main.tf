resource "random_password" "db_pass" {
  length           = 20
  special          = true
  override_special = "!@#$"
}

output "password" {
  value     = random_password.db_pass.result
  sensitive = true
}
