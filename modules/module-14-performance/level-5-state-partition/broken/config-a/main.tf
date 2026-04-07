resource "random_string" "infra_id" {
  length  = 8
  special = false
  upper   = false
}

output "infrastructure_id" {
  value = random_string.infra_id.result
}
