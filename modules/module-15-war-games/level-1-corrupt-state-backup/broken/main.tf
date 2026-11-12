# Meridian Particle Collider — trigger-board chain for the four-station detector ring.
# Each station gets a trigger serial that is burned into its trigger-board firmware.
# The serial is generated ONCE; if it changes, the station drops off the
# trigger system and the next beam fill is lost.

locals {
  stations = {
    north = { clock_khz = 1420.4, ring_angle = 0 }
    south = { clock_khz = 1420.4, ring_angle = 180 }
    east  = { clock_khz = 1665.0, ring_angle = 90 }
    west  = { clock_khz = 1665.0, ring_angle = 270 }
  }
}

resource "random_id" "trigger" {
  for_each    = local.stations
  byte_length = 6
}

resource "local_file" "calibration" {
  for_each = local.stations
  filename = "${path.module}/calibration/station-${each.key}.cfg"
  content  = <<-EOT
    station             = ${each.key}
    trigger_serial  = TG-${random_id.trigger[each.key].b64_url}
    clock_khz         = ${each.value.clock_khz}
    ring_angle_deg      = ${each.value.ring_angle}
  EOT
}

resource "local_file" "ring_roster" {
  filename = "${path.module}/calibration/ring-roster.txt"
  content = join("\n", [
    for k in sort(keys(local.stations)) : "${k}: TG-${random_id.trigger[k].b64_url}"
  ])
}

output "ring_serials" {
  value = { for k, r in random_id.trigger : k => r.b64_url }
}
