# MISSING: lifecycle prevent_destroy on this critical resource
resource "random_string" "critical_token" {
  length  = var.token_length
  special = true
  upper   = true
}

resource "random_string" "auxiliary_token" {
  length  = 8
  special = false
  upper   = false
}

# MISSING: sensitive = true on this output
output "critical_token_value" {
  value = random_string.critical_token.result
}

output "auxiliary_token_value" {
  value = random_string.auxiliary_token.result
}

# MISSING: precondition to verify critical_token length >= 8
output "token_length_check" {
  value = random_string.critical_token.length
}
