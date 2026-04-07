resource "random_string" "rotated_secret" {
  length  = 20
  special = true
  upper   = true
}

resource "random_string" "rotated_token" {
  length  = 16
  special = false
  upper   = false
}

output "secret_result" { value = random_string.rotated_secret.result }
output "token_result"  { value = random_string.rotated_token.result }
