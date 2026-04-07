resource "random_string" "resource_a" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "resource_b" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "resource_c" {
  length  = 12
  special = false
  upper   = false
  keepers = {
    parent_value = random_string.resource_a.result
  }
}

output "a_result" { value = random_string.resource_a.result }
output "b_result" { value = random_string.resource_b.result }
output "c_result" { value = random_string.resource_c.result }
