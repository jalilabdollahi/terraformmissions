resource "random_string" "api_token" {
  length  = 32
  special = false
  keepers = {
    version = "v1"
  }

  lifecycle {
    ignore_changes = [keepers]
  }
}

output "api_token_value" {
  value     = random_string.api_token.result
  sensitive = true
}
