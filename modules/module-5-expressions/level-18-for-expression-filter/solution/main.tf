variable "items" {
  type    = list(string)
  default = ["5", "15", "3", "20"]
}

locals {
  big_items = [for x in var.items : x if tonumber(x) > 10]
}

output "big_items" {
  value = local.big_items
}
