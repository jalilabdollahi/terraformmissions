resource "random_string" "secure_token" {
  length      = 16
  special     = true
  min_lower   = 3
  min_upper   = 3
  min_numeric = 3
  min_special = 3
}

output "token" {
  value     = random_string.secure_token.result
  sensitive = true
}
