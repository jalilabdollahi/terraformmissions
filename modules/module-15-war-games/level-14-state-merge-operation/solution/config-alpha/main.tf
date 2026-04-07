resource "random_string" "alpha_token" {
  length  = 8
  special = false
  upper   = false
}

output "alpha_token_id" {
  value = random_string.alpha_token.result
}
