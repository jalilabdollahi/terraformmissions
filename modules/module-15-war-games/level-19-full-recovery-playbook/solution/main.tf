resource "random_string" "new_name" {
  length  = 10
  special = false
  upper   = false
}

resource "random_string" "config_error" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "healthy_resource" {
  length  = 8
  special = false
  upper   = false
}

# Fix for ISSUE 2: moved block to reconcile old_name → new_name rename
moved {
  from = random_string.old_name
  to   = random_string.new_name
}

output "new_name_result"     { value = random_string.new_name.result }
output "config_error_result" { value = random_string.config_error.result }
output "healthy_result"      { value = random_string.healthy_resource.result }
