resource "random_string" "service_a" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "service_b" {
  length  = 8
  special = false
  upper   = false
}

output "service_a_id" { value = random_string.service_a.result }
output "service_b_id" { value = random_string.service_b.result }
