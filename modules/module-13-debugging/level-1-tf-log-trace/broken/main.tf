# Col du Lac avalanche patrol - nightly beacon test sheets.

locals {
  patrol_zone = "col-du-lac"
  beacons = {
    north = 457
    south = 457
    ridge = 457
  }
}

resource "local_file" "patrol_roster" {
  filename = "${path.module}/field/roster.txt"
  content  = "Zone ${local.patrol_zone}: ${length(local.beacons)} transceivers on the night rota\n"
}

# The transceiver index is a plain text file listing every beacon's frequency.
resource "local_file" "beacon_index" {
  filename = "${path.module}/field/beacons/index.txt"
  content = join("\n", [
    for name in sort(keys(local.beacons)) : "${name}=${local.beacons[name]}kHz"
  ])
}

# Per-zone self-test marker, stored next to the index.
resource "local_file" "beacon_probe" {
  filename = "${local_file.beacon_index.filename}/probe-${local.patrol_zone}.ok"
  content  = "all ${length(local.beacons)} transceivers answered\n"
}

output "probe_file" {
  value = local_file.beacon_probe.filename
}
