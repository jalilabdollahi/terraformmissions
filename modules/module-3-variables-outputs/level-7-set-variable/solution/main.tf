variable "unique_tags" {
  type    = set(string)
  default = ["a", "b"]
}

output "unique_tags" {
  value = var.unique_tags
}
