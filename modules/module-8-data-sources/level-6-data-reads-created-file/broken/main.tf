# Cosmetics lab: the batch sheet is generated first, then re-read to work out the fragrance dose.

variable "base_grams" {
  type    = number
  default = 240
}

resource "local_file" "batch_sheet" {
  filename = "${path.module}/bench/batch-sheet.txt"
  content  = "base_g=${var.base_grams}\nfragrance_pct=6\npreservative=phenoxy-1\n"
}

data "local_file" "batch_sheet" {
  filename = "${path.module}/bench/batch-sheet.txt"
}

locals {
  sheet        = data.local_file.batch_sheet.content
  base_g        = tonumber(regex("base_g=([0-9.]+)", local.sheet)[0])
  fragrance_pc = tonumber(regex("fragrance_pct=([0-9.]+)", local.sheet)[0])
}

resource "local_file" "dose_label" {
  filename = "${path.module}/bench/dose-label.txt"
  content  = "Fragrance oil: ${local.base_g * local.fragrance_pc / 100} g for ${local.base_g} g of base\n"
}

output "fragrance_g" {
  value = local.base_g * local.fragrance_pc / 100
}
