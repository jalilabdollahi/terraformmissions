# Harrow Chocolate Tempering Hall — tempering-hall control files, managed as code.
# Every file under kettles/, recipes/ and molds/ is read by the tempering-hall PLCs.

locals {
  chill_seconds = 40
  melt_temp_f    = 122
}

# The cocoa lot is printed on every wrapper. It is generated once per campaign.
resource "random_id" "cocoa_lot" {
  byte_length = 3
}

resource "local_file" "kettle_a" {
  filename = "${path.module}/kettles/kettle-a.cfg"
  content  = <<-EOT
    kettle        = A
    cocoa_lot      = CL-${random_id.cocoa_lot.hex}
    chill_seconds = ${local.chill_seconds}
  EOT
}

resource "local_file" "kettle_b" {
  filename = "${path.module}/kettles/kettle-b.cfg"
  content  = <<-EOT
    kettle        = B
    cocoa_lot      = CL-${random_id.cocoa_lot.hex}
    bowl_warm_c     = 29
  EOT
}

resource "local_file" "dark_temper" {
  filename = "${path.module}/recipes/dark-temper.cfg"
  content  = <<-EOT
    couverture     = couverture-dark70
    melt_temp_f   = ${local.melt_temp_f}
  EOT
}

resource "local_file" "shift_board" {
  filename = "${path.module}/floor/shift-board.txt"
  content  = "Campaign cocoa lot CL-${random_id.cocoa_lot.hex}, melt at ${local.melt_temp_f} C\n"
}

output "cocoa_lot" {
  value = "CL-${random_id.cocoa_lot.hex}"
}
