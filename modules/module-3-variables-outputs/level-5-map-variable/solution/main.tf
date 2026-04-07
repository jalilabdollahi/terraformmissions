variable "labels" {
  type = map(string)
  default = {
    a = "x"
    b = "2"
  }
}

output "labels" {
  value = var.labels
}
