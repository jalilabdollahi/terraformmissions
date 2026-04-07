resource "random_password" "db_pass" {
  length  = 16
  special = true
}

# Bug: writing sensitive value to local_file exposes it with world-readable permissions
resource "local_file" "secret" {
  content  = random_password.db_pass.result
  filename = "${path.module}/secret.txt"
}

output "db_password" {
  value = random_password.db_pass.result
  # Missing: sensitive = true
}
