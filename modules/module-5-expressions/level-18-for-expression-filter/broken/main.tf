variable "items" {
  type    = list(string)
  default = ["5", "15", "3", "20"]
}

# BUG: var.items is list(string) — comparing strings to number 10 with > is a type error
locals {
  big_items = [for x in var.items : x if x > 10]
}

output "big_items" {
  value = local.big_items
}
