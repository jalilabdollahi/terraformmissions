# ISSUE 1: There is a stale random_id.old_resource in state (needs state rm).
# ISSUE 2: random_string.new_name was previously called random_string.old_name
#          — needs a moved block.
# ISSUE 3: random_string.config_error has length = 0 (invalid) — fix to length = 8.

resource "random_string" "new_name" {
  length  = 10
  special = false
  upper   = false
}

resource "random_string" "config_error" {
  length  = 0
  special = false
  upper   = false
}

resource "random_string" "healthy_resource" {
  length  = 8
  special = false
  upper   = false
}

output "new_name_result"     { value = random_string.new_name.result }
output "config_error_result" { value = random_string.config_error.result }
output "healthy_result"      { value = random_string.healthy_resource.result }
