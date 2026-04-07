# This resource is permanent and should have prevent_destroy protection.
resource "random_string" "protected_data" {
  length  = 16
  special = false
  upper   = false
}

# This resource is temporary and needs to be destroyed.
# BUG: prevent_destroy was accidentally put here instead of on protected_data.
# Fix: remove the lifecycle block from this resource.
resource "random_string" "temp_resource" {
  length  = 8
  special = false
  upper   = false

  lifecycle {
    prevent_destroy = true
  }
}

output "protected_id" { value = random_string.protected_data.result }
output "temp_id"      { value = random_string.temp_resource.result }
