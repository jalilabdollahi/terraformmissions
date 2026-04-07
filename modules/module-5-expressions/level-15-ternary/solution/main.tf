variable "enabled" {
  type    = bool
  default = true
}

locals {
  status = var.enabled ? "yes" : "no"
}

output "status" {
  value = local.status
}
