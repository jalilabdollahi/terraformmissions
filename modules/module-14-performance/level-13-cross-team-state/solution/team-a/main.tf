resource "random_string" "cluster_id" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "vpc_id" {
  length  = 12
  special = false
  upper   = false
}

output "cluster_identifier" {
  value       = random_string.cluster_id.result
  description = "Unique cluster identifier — consumed by team-b"
}

output "network_id" {
  value       = random_string.vpc_id.result
  description = "Network identifier — consumed by team-b"
}
