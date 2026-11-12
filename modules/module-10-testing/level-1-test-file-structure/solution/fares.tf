variable "zones" {
  description = "How many fare zones the journey crosses."
  type        = number
  default     = 1
}

variable "child" {
  description = "Child passengers pay half fare, rounded down."
  type        = bool
  default     = false
}

locals {
  base_cents     = 140
  per_zone_cents = 55
  adult_fare     = local.base_cents + (var.zones - 1) * local.per_zone_cents
}

output "fare_cents" {
  value = var.child ? floor(local.adult_fare / 2) : local.adult_fare
}
