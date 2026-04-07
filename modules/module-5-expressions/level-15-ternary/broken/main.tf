variable "enabled" {
  type    = bool
  default = true
}

# BUG: mismatched types — "yes" is string, 0 is number
locals {
  status = var.enabled ? "yes" : 0
}

output "status" {
  value = local.status
}
