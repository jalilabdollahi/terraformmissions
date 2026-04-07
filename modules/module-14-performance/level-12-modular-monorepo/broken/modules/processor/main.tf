resource "random_string" "processed" {
  length  = 8
  special = false
  upper   = false
  keepers = {
    source = var.input_id
  }
}

output "processed_value" {
  value = random_string.processed.result
}
