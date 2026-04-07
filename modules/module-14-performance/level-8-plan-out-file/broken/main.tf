# BUG: min_lower + min_upper + min_numeric + min_special must be <= length.
# Here: 5 + 5 + 5 + 5 = 20, but length = 12. This is invalid.
resource "random_string" "secure_token" {
  length      = 12
  special     = true
  min_lower   = 5
  min_upper   = 5
  min_numeric = 5
  min_special = 5
}

output "token" {
  value     = random_string.secure_token.result
  sensitive = true
}
