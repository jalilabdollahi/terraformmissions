# BUG: random_password with invalid length — must be >= 1
resource "random_password" "secret" {
  length  = 0
  special = true
}

output "secret_length" {
  value = length(random_password.secret.result)
}
