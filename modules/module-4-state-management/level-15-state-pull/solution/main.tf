resource "random_password" "secret" {
  length  = 16
  special = true
}

output "secret_length" {
  value = length(random_password.secret.result)
}
