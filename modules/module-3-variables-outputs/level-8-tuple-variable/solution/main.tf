variable "app_info" {
  type    = tuple([string, number])
  default = ["hello", 42]
}

output "app_name" {
  value = var.app_info[0]
}

output "app_version" {
  value = var.app_info[1]
}
