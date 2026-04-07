resource "random_string" "value" {
  length  = 8
  special = false
  upper   = false
}

output "output_value" {
  value = random_string.value.result
}
