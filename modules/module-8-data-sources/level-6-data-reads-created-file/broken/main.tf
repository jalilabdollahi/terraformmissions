# Candle workshop: the pour sheet is generated first, then re-read to work out the fragrance dose.

variable "wax_grams" {
  type    = number
  default = 240
}

resource "local_file" "pour_sheet" {
  filename = "${path.module}/bench/pour-sheet.txt"
  content  = "wax_g=${var.wax_grams}\nfragrance_pct=6\nwick=cotton-4\n"
}

data "local_file" "pour_sheet" {
  filename = "${path.module}/bench/pour-sheet.txt"
}

locals {
  sheet        = data.local_file.pour_sheet.content
  wax_g        = tonumber(regex("wax_g=([0-9.]+)", local.sheet)[0])
  fragrance_pc = tonumber(regex("fragrance_pct=([0-9.]+)", local.sheet)[0])
}

resource "local_file" "dose_label" {
  filename = "${path.module}/bench/dose-label.txt"
  content  = "Fragrance oil: ${local.wax_g * local.fragrance_pc / 100} g for ${local.wax_g} g of wax\n"
}

output "fragrance_g" {
  value = local.wax_g * local.fragrance_pc / 100
}
