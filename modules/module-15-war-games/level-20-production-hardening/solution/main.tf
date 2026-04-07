resource "random_string" "critical_token" {
  length  = var.token_length
  special = true
  upper   = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "random_string" "auxiliary_token" {
  length  = 8
  special = false
  upper   = false
}

output "critical_token_value" {
  value     = random_string.critical_token.result
  sensitive = true
}

output "auxiliary_token_value" {
  value = random_string.auxiliary_token.result
}

output "token_length_check" {
  value = random_string.critical_token.length

  precondition {
    condition     = random_string.critical_token.length >= 8
    error_message = "Critical token length must be >= 8. Current: ${random_string.critical_token.length}"
  }
}
