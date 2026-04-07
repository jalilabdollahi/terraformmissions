# BUG: set(string) does not allow duplicate elements.
# "a" appears twice in the default value.

variable "unique_tags" {
  type    = set(string)
  default = ["a", "b", "a"]
}

output "unique_tags" {
  value = var.unique_tags
}
