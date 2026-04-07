resource "random_string" "token" {
  length  = 12
  special = false
  upper   = false
}

output "token_id" {
  value = random_string.token.result
}
