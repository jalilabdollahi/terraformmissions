variable "instance_count" {
  type    = number
  default = 2
}

output "count" {
  value = var.instance_count
}
