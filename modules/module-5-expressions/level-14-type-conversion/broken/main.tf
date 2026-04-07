variable "my_map" {
  type = map(string)
  default = {
    a = "apple"
    b = "banana"
  }
}

# BUG: tolist() cannot convert a map to a list
locals {
  as_list = tolist(var.my_map)
}

output "as_list" {
  value = local.as_list
}
