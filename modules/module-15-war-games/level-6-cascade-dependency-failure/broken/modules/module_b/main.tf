resource "random_string" "value" {
  length  = 10
  special = false
  upper   = false
  keepers = { upstream = var.input_a }
}

output "output_value" {
  value = "${var.input_a}-${random_string.value.result}"
}
