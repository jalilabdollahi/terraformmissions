# Brightbox Jigsaw Factory: piece press index.
#
# The catalogue is decoded once; every resource and output reads the local value.

locals {
  pieces      = jsondecode(file("${path.module}/data/pieces.json")).pieces
  piece_count = length(local.pieces)
  checksum   = sha256(jsonencode(local.pieces))
  quadrants    = ["north", "south", "east", "west"]

  ids_by_quadrant = {
    for r in local.quadrants :
    r => sort([for t in local.pieces : t.id if t.quadrant == r])
  }
}

resource "local_file" "north_index" {
  filename = "${path.module}/puzzle/north.txt"
  content  = "${join("\n", local.ids_by_quadrant["north"])}\n"
}

resource "local_file" "south_index" {
  filename = "${path.module}/puzzle/south.txt"
  content  = "${join("\n", local.ids_by_quadrant["south"])}\n"
}

resource "local_file" "east_index" {
  filename = "${path.module}/puzzle/east.txt"
  content  = "${join("\n", local.ids_by_quadrant["east"])}\n"
}

resource "local_file" "west_index" {
  filename = "${path.module}/puzzle/west.txt"
  content  = "${join("\n", local.ids_by_quadrant["west"])}\n"
}

resource "local_file" "summary" {
  filename = "${path.module}/puzzle/summary.txt"
  content  = <<-EOT
    pieces: ${local.piece_count}
    megabytes: ${floor(sum([for t in local.pieces : t.bytes]) / 1048576)}
    highest complexity: ${max([for t in local.pieces : t.complexity]...)}
    checksum: ${local.checksum}
  EOT
}

resource "local_file" "audit_stamp" {
  filename = "${path.module}/puzzle/audit.txt"
  content  = "audit ${local.checksum} over ${local.piece_count} pieces\n"
}

output "checksum" {
  value = local.checksum
}

output "quadrant_counts" {
  value = { for r in local.quadrants : r => length(local.ids_by_quadrant[r]) }
}
