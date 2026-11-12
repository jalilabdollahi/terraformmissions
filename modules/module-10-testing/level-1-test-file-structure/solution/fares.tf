variable "axles" {
  description = "How many axles the vehicle has."
  type        = number
  default     = 1
}

variable "discount" {
  description = "Discount-pass holders pay half fare, rounded down."
  type        = bool
  default     = false
}

locals {
  base_cents     = 140
  per_axle_cents = 55
  adult_fare     = local.base_cents + (var.axles - 1) * local.per_axle_cents
}

output "fare_cents" {
  value = var.discount ? floor(local.adult_fare / 2) : local.adult_fare
}
