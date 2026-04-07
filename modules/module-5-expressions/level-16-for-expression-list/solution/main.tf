variable "items" {
  type    = list(string)
  default = ["apple", "banana", "cherry"]
}

locals {
  values = [for item in var.items : upper(item)]
}

output "values" {
  value = local.values
}
