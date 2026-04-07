resource "random_password" "db_pass" {
  length  = 16
  special = true
}

resource "local_sensitive_file" "secret" {
  content  = random_password.db_pass.result
  filename = "${path.module}/secret.txt"
}

output "db_password" {
  value     = random_password.db_pass.result
  sensitive = true
}
