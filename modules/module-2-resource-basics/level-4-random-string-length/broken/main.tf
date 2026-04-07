# BUG: length = 0 is invalid. The minimum value for length is 1.

resource "random_string" "token" {
  length  = 0
  special = false
  upper   = false
}

output "token" {
  value = random_string.token.result
}
