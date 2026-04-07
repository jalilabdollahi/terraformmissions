resource "random_string" "b_value" {
  length  = 8
  special = false
  upper   = false
  keepers = { seed = var.input_from_a }
}

output "output_b" {
  value = random_string.b_value.result
}
