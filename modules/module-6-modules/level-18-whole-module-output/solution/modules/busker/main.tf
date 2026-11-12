variable "performer" {
  type = string
}

variable "setlist" {
  type = list(string)
}

output "performer" {
  value = var.performer
}

output "slot" {
  value = 40 + length(var.setlist)
}

output "setlist" {
  value = sort(var.setlist)
}
