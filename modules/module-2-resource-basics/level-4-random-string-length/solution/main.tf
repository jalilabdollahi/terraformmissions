resource "random_string" "token" {
  length  = 16
  special = false
  upper   = false
}

output "token" {
  value = random_string.token.result
}
