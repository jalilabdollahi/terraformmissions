# BUG: The third element (3) is a number, not a string.
# list(string) requires ALL elements to be strings.

variable "tags" {
  type    = list(string)
  default = ["a", "b", 3]
}

output "tags" {
  value = var.tags
}
