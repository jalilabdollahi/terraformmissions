resource "random_string" "service_token" {
  length  = 16
  special = false
  upper   = false
}

output "token_value" {
  value     = random_string.service_token.result
  sensitive = true
}
