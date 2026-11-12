# Meridian Radio Observatory — receiver chain for the four-dish array.
# Each dish gets a receiver serial that is burned into its front-end firmware.
# The serial is generated ONCE; if it changes, the dish drops off the
# correlator and the next observing block is lost.

locals {
  dishes = {
    north = { band_mhz = 1420.4, azimuth = 0 }
    south = { band_mhz = 1420.4, azimuth = 180 }
    east  = { band_mhz = 1665.0, azimuth = 90 }
    west  = { band_mhz = 1665.0, azimuth = 270 }
  }
}

resource "random_id" "receiver" {
  for_each    = local.dishes
  byte_length = 6
}

resource "local_file" "calibration" {
  for_each = local.dishes
  filename = "${path.module}/calibration/dish-${each.key}.cfg"
  content  = <<-EOT
    dish             = ${each.key}
    receiver_serial  = RX-${random_id.receiver[each.key].b64_url}
    band_mhz         = ${each.value.band_mhz}
    azimuth_deg      = ${each.value.azimuth}
  EOT
}

resource "local_file" "array_roster" {
  filename = "${path.module}/calibration/array-roster.txt"
  content = join("\n", [
    for k in sort(keys(local.dishes)) : "${k}: RX-${random_id.receiver[k].b64_url}"
  ])
}

output "array_serials" {
  value = { for k, r in random_id.receiver : k => r.b64_url }
}
