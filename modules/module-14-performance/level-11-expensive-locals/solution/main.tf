# Brightbox Kaleidoscope Workshop: shard tray index.
#
# The catalogue is decoded once; every resource and output reads the local value.

locals {
  shards      = jsondecode(file("${path.module}/data/shards.json")).shards
  shard_count = length(local.shards)
  checksum    = sha256(jsonencode(local.shards))
  quadrants   = ["north", "south", "east", "west"]

  ids_by_quadrant = {
    for r in local.quadrants :
    r => sort([for t in local.shards : t.id if t.quadrant == r])
  }
}

resource "local_file" "north_index" {
  filename = "${path.module}/kaleidoscope/north.txt"
  content  = "${join("\n", local.ids_by_quadrant["north"])}\n"
}

resource "local_file" "south_index" {
  filename = "${path.module}/kaleidoscope/south.txt"
  content  = "${join("\n", local.ids_by_quadrant["south"])}\n"
}

resource "local_file" "east_index" {
  filename = "${path.module}/kaleidoscope/east.txt"
  content  = "${join("\n", local.ids_by_quadrant["east"])}\n"
}

resource "local_file" "west_index" {
  filename = "${path.module}/kaleidoscope/west.txt"
  content  = "${join("\n", local.ids_by_quadrant["west"])}\n"
}

resource "local_file" "summary" {
  filename = "${path.module}/kaleidoscope/summary.txt"
  content  = <<-EOT
    shards: ${local.shard_count}
    megabytes: ${floor(sum([for t in local.shards : t.bytes]) / 1048576)}
    highest complexity: ${max([for t in local.shards : t.complexity]...)}
    checksum: ${local.checksum}
  EOT
}

resource "local_file" "audit_stamp" {
  filename = "${path.module}/kaleidoscope/audit.txt"
  content  = "audit ${local.checksum} over ${local.shard_count} shards\n"
}

output "checksum" {
  value = local.checksum
}

output "quadrant_counts" {
  value = { for r in local.quadrants : r => length(local.ids_by_quadrant[r]) }
}
