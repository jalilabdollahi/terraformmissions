# BUG: tuple([string, number]) requires the second element to be a number.
# "world" is a string, not a number.

variable "app_info" {
  type    = tuple([string, number])
  default = ["hello", "world"]
}

output "app_name" {
  value = var.app_info[0]
}

output "app_version" {
  value = var.app_info[1]
}
