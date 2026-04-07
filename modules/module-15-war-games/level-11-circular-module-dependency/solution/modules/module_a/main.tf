resource "random_string" "a_value" {
  length  = 8
  special = false
  upper   = false
  keepers = { seed = var.shared_seed }
}

output "output_a" {
  value = random_string.a_value.result
}
