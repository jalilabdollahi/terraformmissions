variable "debug" {
  type    = string
  default = "true"
}

# BUG: %{if} requires a bool but var.debug is string "true", not bool true
locals {
  message = "%{if var.debug}DEBUG MODE ENABLED%{endif}"
}

output "message" {
  value = local.message
}
