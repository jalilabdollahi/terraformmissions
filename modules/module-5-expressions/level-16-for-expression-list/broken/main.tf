variable "items" {
  type    = list(string)
  default = ["apple", "banana", "cherry"]
}

# BUG: var.items is list(string) — items are strings, not objects.
# Accessing .value on a string element causes an error.
locals {
  values = [for item in var.items : item.value]
}

output "values" {
  value = local.values
}
