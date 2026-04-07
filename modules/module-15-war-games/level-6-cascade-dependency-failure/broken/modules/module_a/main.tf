resource "random_string" "value" {
  length  = 8
  special = false
  upper   = false
}

# BUG: random_string does not have an "id" attribute. Use "result".
output "output_value" {
  value = random_string.value.id
}
