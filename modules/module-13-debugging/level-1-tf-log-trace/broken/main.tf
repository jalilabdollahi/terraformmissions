# Frostline Snowmobile Tours - nightly sled check sheets.

locals {
  tour_route = "glacier-loop"
  sleds = {
    north = 457
    south = 457
    ridge = 457
  }
}

resource "local_file" "tour_roster" {
  filename = "${path.module}/depot/roster.txt"
  content  = "Route ${local.tour_route}: ${length(local.sleds)} sleds on the night rota\n"
}

# The sled index is a plain text file listing every sled's engine size.
resource "local_file" "sled_index" {
  filename = "${path.module}/depot/sleds/index.txt"
  content = join("\n", [
    for name in sort(keys(local.sleds)) : "${name}=${local.sleds[name]}cc"
  ])
}

# Per-route self-test marker, stored next to the index.
resource "local_file" "sled_probe" {
  filename = "${local_file.sled_index.filename}/probe-${local.tour_route}.ok"
  content  = "all ${length(local.sleds)} sleds started\n"
}

output "probe_file" {
  value = local_file.sled_probe.filename
}
