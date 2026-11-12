variable "unit" {
  description = "Storage unit label."
  type        = string
  default     = "A-14"
}

resource "random_password" "lock" {
  length  = 8
  special = false
  upper   = false
  lower   = false
  numeric = true
}

output "lock_code" {
  value     = random_password.lock.result
  sensitive = true
}

output "unit_label" {
  value = "Unit ${var.unit}"
}
