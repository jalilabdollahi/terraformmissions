# Brightbox Jigsaw Factory: piece press index.
#
# Every piece of the puzzle is listed in data/pieces.json. Each resource below decodes the file and
# loops over it on its own, and the checksum is recomputed in three places. With the real catalogue
# (tens of thousands of pieces) a plan spends most of its time doing this one job five times over.

resource "local_file" "north_index" {
  filename = "${path.module}/puzzle/north.txt"
  content  = "${join("\n", sort([for t in jsondecode(file("${path.module}/data/pieces.json")).pieces : t.id if t.quadrant == "north"]))}\n"
}

resource "local_file" "south_index" {
  filename = "${path.module}/puzzle/south.txt"
  content  = "${join("\n", sort([for t in jsondecode(file("${path.module}/data/pieces.json")).pieces : t.id if t.quadrant == "south"]))}\n"
}

resource "local_file" "east_index" {
  filename = "${path.module}/puzzle/east.txt"
  content  = "${join("\n", sort([for t in jsondecode(file("${path.module}/data/pieces.json")).pieces : t.id if t.quadrant == "east"]))}\n"
}

resource "local_file" "west_index" {
  filename = "${path.module}/puzzle/west.txt"
  content  = "${join("\n", sort([for t in jsondecode(file("${path.module}/data/pieces.json")).pieces : t.id if t.quadrant == "west"]))}\n"
}

resource "local_file" "summary" {
  filename = "${path.module}/puzzle/summary.txt"
  content  = <<-EOT
    pieces: ${length(jsondecode(file("${path.module}/data/pieces.json")).pieces)}
    megabytes: ${floor(sum([for t in jsondecode(file("${path.module}/data/pieces.json")).pieces : t.bytes]) / 1048576)}
    highest complexity: ${max([for t in jsondecode(file("${path.module}/data/pieces.json")).pieces : t.complexity]...)}
    checksum: ${sha256(jsonencode(jsondecode(file("${path.module}/data/pieces.json")).pieces))}
  EOT
}

resource "local_file" "audit_stamp" {
  filename = "${path.module}/puzzle/audit.txt"
  content  = "audit ${sha256(jsonencode(jsondecode(file("${path.module}/data/pieces.json")).pieces))} over ${length(jsondecode(file("${path.module}/data/pieces.json")).pieces)} pieces\n"
}

output "checksum" {
  value = sha256(jsonencode(jsondecode(file("${path.module}/data/pieces.json")).pieces))
}

output "quadrant_counts" {
  value = {
    for r in ["north", "south", "east", "west"] :
    r => length([for t in jsondecode(file("${path.module}/data/pieces.json")).pieces : t if t.quadrant == r])
  }
}
