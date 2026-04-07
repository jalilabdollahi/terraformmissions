variable "item_count" {
  type    = number
  default = 1
}

output "item_count" {
  value = var.item_count
}
