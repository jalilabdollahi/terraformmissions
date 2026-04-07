resource "random_uuid" "app_id" {}

# BUG: random_uuid exposes the UUID as .id, not .result
output "app_id" {
  value = random_uuid.app_id.result
}
