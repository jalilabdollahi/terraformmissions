variable "tags" {
  type    = list(string)
  default = ["a", "b", "3"]
}

output "tags" {
  value = var.tags
}
