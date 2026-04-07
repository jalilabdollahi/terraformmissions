# DRIFT 1: This resource should have length=16 but is configured as length=8
resource "random_string" "api_key" {
  length  = 8
  special = false
  upper   = false
}

# DRIFT 2: This resource should have special=true but is configured as special=false
resource "random_string" "session_token" {
  length  = 12
  special = false
  upper   = false
}

# DRIFT 3: This resource should have upper=true but is configured as upper=false
resource "random_string" "admin_token" {
  length  = 10
  special = false
  upper   = false
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
