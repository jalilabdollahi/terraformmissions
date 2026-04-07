# Resource A — generates a random ID
resource "random_string" "resource_a" {
  length  = 8
  special = false
  upper   = false
}

# Resource B — independent resource
resource "random_string" "resource_b" {
  length  = 8
  special = false
  upper   = false
}

# Resource C — depends on A, but references the WRONG attribute.
# random_string does not have an attribute called "id". Use "result".
resource "random_string" "resource_c" {
  length  = 12
  special = false
  upper   = false
  keepers = {
    parent_value = random_string.resource_a.id
  }
}

output "a_result" { value = random_string.resource_a.result }
output "b_result" { value = random_string.resource_b.result }
output "c_result" { value = random_string.resource_c.result }
