variable "prints" {
  description = "How many prints the customer orders."
  type        = number
  default     = 1
}

variable "discount" {
  description = "Loyalty-card holders pay half price, rounded down."
  type        = bool
  default     = false
}

locals {
  base_cents      = 140
  per_print_cents = 55
  standard_price  = local.base_cents + (var.prints - 1) * local.per_print_cents
}

output "price_cents" {
  value = var.discount ? floor(local.standard_price / 2) : local.standard_price
}
