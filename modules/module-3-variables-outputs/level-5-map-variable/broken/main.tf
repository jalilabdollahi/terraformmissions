# BUG: map(string) requires all values to be strings.
# The value for key "b" is the number 2, not a string.

variable "labels" {
  type = map(string)
  default = {
    a = "x"
    b = 2
  }
}

output "labels" {
  value = var.labels
}
