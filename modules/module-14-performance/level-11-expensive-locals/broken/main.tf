# Harborline Cartographers: tile press index.
#
# Every tile of the atlas is listed in data/tiles.json. Each resource below decodes the file and
# loops over it on its own, and the checksum is recomputed in three places. With the real atlas
# (tens of thousands of tiles) a plan spends most of its time doing this one job five times over.

resource "local_file" "north_index" {
  filename = "${path.module}/atlas/north.txt"
  content  = "${join("\n", sort([for t in jsondecode(file("${path.module}/data/tiles.json")).tiles : t.id if t.region == "north"]))}\n"
}

resource "local_file" "south_index" {
  filename = "${path.module}/atlas/south.txt"
  content  = "${join("\n", sort([for t in jsondecode(file("${path.module}/data/tiles.json")).tiles : t.id if t.region == "south"]))}\n"
}

resource "local_file" "east_index" {
  filename = "${path.module}/atlas/east.txt"
  content  = "${join("\n", sort([for t in jsondecode(file("${path.module}/data/tiles.json")).tiles : t.id if t.region == "east"]))}\n"
}

resource "local_file" "west_index" {
  filename = "${path.module}/atlas/west.txt"
  content  = "${join("\n", sort([for t in jsondecode(file("${path.module}/data/tiles.json")).tiles : t.id if t.region == "west"]))}\n"
}

resource "local_file" "summary" {
  filename = "${path.module}/atlas/summary.txt"
  content  = <<-EOT
    tiles: ${length(jsondecode(file("${path.module}/data/tiles.json")).tiles)}
    megabytes: ${floor(sum([for t in jsondecode(file("${path.module}/data/tiles.json")).tiles : t.bytes]) / 1048576)}
    deepest zoom: ${max([for t in jsondecode(file("${path.module}/data/tiles.json")).tiles : t.zoom]...)}
    checksum: ${sha256(jsonencode(jsondecode(file("${path.module}/data/tiles.json")).tiles))}
  EOT
}

resource "local_file" "audit_stamp" {
  filename = "${path.module}/atlas/audit.txt"
  content  = "audit ${sha256(jsonencode(jsondecode(file("${path.module}/data/tiles.json")).tiles))} over ${length(jsondecode(file("${path.module}/data/tiles.json")).tiles)} tiles\n"
}

output "checksum" {
  value = sha256(jsonencode(jsondecode(file("${path.module}/data/tiles.json")).tiles))
}

output "region_counts" {
  value = {
    for r in ["north", "south", "east", "west"] :
    r => length([for t in jsondecode(file("${path.module}/data/tiles.json")).tiles : t if t.region == r])
  }
}
