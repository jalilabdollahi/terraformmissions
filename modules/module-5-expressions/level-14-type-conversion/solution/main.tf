variable "my_map" {
  type = map(string)
  default = {
    a = "apple"
    b = "banana"
  }
}

locals {
  as_list = values(var.my_map)
}

output "as_list" {
  value = local.as_list
}
