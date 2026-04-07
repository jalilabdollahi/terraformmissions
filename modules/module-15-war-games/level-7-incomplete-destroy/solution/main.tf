resource "random_string" "resource_active" {
  length  = 8
  special = false
  upper   = false
}

# removed blocks: tell Terraform to forget these resources from state
# without attempting to destroy the underlying infrastructure.
removed {
  from = random_string.resource_ghost_a
  lifecycle {
    destroy = false
  }
}

removed {
  from = random_string.resource_ghost_b
  lifecycle {
    destroy = false
  }
}

output "active_id" {
  value = random_string.resource_active.result
}
