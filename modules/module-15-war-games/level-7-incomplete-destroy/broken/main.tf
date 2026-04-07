# The config currently only manages resource_active.
# But the state file also records resource_ghost_a and resource_ghost_b
# from a previous deployment that was partially destroyed.
# These ghost resources cause errors during plan/apply.
# Fix: add removed {} blocks to cleanly deregister them from state.
resource "random_string" "resource_active" {
  length  = 8
  special = false
  upper   = false
}

output "active_id" {
  value = random_string.resource_active.result
}
