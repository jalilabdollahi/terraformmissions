resource "random_string" "api_key" {
  length  = 16
  special = false
  upper   = false
}

resource "random_string" "session_token" {
  length  = 12
  special = true
  upper   = false
}

resource "random_string" "admin_token" {
  length  = 10
  special = false
  upper   = true
}

output "api_key_length" {
  value = random_string.api_key.length
}

output "session_has_special" {
  value = random_string.session_token.special
}

output "admin_has_upper" {
  value = random_string.admin_token.upper
}
