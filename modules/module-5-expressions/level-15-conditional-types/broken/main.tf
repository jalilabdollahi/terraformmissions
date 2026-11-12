# Stubai Ridge ski resort — day-pass desk.
# Peak season opens more lifts; juniors pay half price.

variable "peak_season" {
  type    = bool
  default = true
}

variable "junior" {
  type    = bool
  default = false
}

variable "base_price_eur" {
  type    = number
  default = 64
}

locals {
  lifts           = var.peak_season ? ["north", "summit", "glacier"] : "north"
  discount_factor = var.junior ? 0.5 : "full"
  price_eur       = var.base_price_eur * local.discount_factor
}

resource "local_file" "pass_slip" {
  filename = "${path.module}/desk/pass.txt"
  content  = "Lifts: ${join(", ", local.lifts)}\nPrice: ${local.price_eur} EUR\n"
}

output "lifts" {
  value = local.lifts
}

output "discount_factor" {
  value = local.discount_factor
}

output "price_eur" {
  value = local.price_eur
}
