# The state file records this resource as "random_id.legacy_id" (old type).
# The config now uses "random_string.service_token" (new type).
# This causes a type mismatch — state has old type, config has new type.
# Fix options:
# 1. Remove the old entry from state: terraform state rm random_id.legacy_id
# 2. Add a moved block (not applicable for type changes — only address changes)
# 3. Simply apply — Terraform will detect the resource isn't in state and create it fresh.
#
# For this exercise: the state file already has the stale entry removed (it was corrupt).
# Just apply cleanly.
resource "random_string" "service_token" {
  length  = 16
  special = false
  upper   = false
}

output "token_value" {
  value     = random_string.service_token.result
  sensitive = true
}
