resource "random_string" "infra_token" {
  length  = 12
  special = false
  upper   = false
}

output "infra_token" {
  value       = random_string.infra_token.result
  description = "Infrastructure token — shared with team2 via remote state"
}
