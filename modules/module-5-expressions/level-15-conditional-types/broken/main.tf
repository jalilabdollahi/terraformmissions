# Tarn Hollow zip-line park — ride-pass desk.
# Peak season opens more zip lines; juniors pay half price.

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
  zips            = var.peak_season ? ["canopy", "gorge", "valley"] : "canopy"
  discount_factor = var.junior ? 0.5 : "full"
  price_eur       = var.base_price_eur * local.discount_factor
}

resource "local_file" "pass_slip" {
  filename = "${path.module}/desk/pass.txt"
  content  = "Zips: ${join(", ", local.zips)}\nPrice: ${local.price_eur} EUR\n"
}

output "zips" {
  value = local.zips
}

output "discount_factor" {
  value = local.discount_factor
}

output "price_eur" {
  value = local.price_eur
}
