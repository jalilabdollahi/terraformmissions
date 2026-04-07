variable "debug" {
  type    = bool
  default = true
}

locals {
  message = "%{if var.debug}DEBUG MODE ENABLED%{endif}"
}

output "message" {
  value = local.message
}
