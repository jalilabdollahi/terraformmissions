resource "random_string" "beta_token" {
  length  = 10
  special = false
  upper   = false
}

output "beta_token_id" {
  value = random_string.beta_token.result
}
