# Harborline Cartographers: tile press index.
#
# The atlas is decoded once; every resource and output reads the local value.

locals {
  tiles      = jsondecode(file("${path.module}/data/tiles.json")).tiles
  tile_count = length(local.tiles)
  checksum   = sha256(jsonencode(local.tiles))
  regions    = ["north", "south", "east", "west"]

  ids_by_region = {
    for r in local.regions :
    r => sort([for t in local.tiles : t.id if t.region == r])
  }
}

resource "local_file" "north_index" {
  filename = "${path.module}/atlas/north.txt"
  content  = "${join("\n", local.ids_by_region["north"])}\n"
}

resource "local_file" "south_index" {
  filename = "${path.module}/atlas/south.txt"
  content  = "${join("\n", local.ids_by_region["south"])}\n"
}

resource "local_file" "east_index" {
  filename = "${path.module}/atlas/east.txt"
  content  = "${join("\n", local.ids_by_region["east"])}\n"
}

resource "local_file" "west_index" {
  filename = "${path.module}/atlas/west.txt"
  content  = "${join("\n", local.ids_by_region["west"])}\n"
}

resource "local_file" "summary" {
  filename = "${path.module}/atlas/summary.txt"
  content  = <<-EOT
    tiles: ${local.tile_count}
    megabytes: ${floor(sum([for t in local.tiles : t.bytes]) / 1048576)}
    deepest zoom: ${max([for t in local.tiles : t.zoom]...)}
    checksum: ${local.checksum}
  EOT
}

resource "local_file" "audit_stamp" {
  filename = "${path.module}/atlas/audit.txt"
  content  = "audit ${local.checksum} over ${local.tile_count} tiles\n"
}

output "checksum" {
  value = local.checksum
}

output "region_counts" {
  value = { for r in local.regions : r => length(local.ids_by_region[r]) }
}
