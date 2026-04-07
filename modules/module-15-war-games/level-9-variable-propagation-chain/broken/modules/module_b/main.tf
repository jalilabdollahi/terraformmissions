resource "random_string" "token" {
  length  = var.token_length
  special = false
  upper   = false
}

output "generated_token" {
  value = random_string.token.result
}
