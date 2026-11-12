variable "owner" {
  type = string
}

variable "catch" {
  type = list(string)
}

output "owner" {
  value = var.owner
}

output "pitch" {
  value = 40 + length(var.catch)
}

output "catch" {
  value = sort(var.catch)
}
