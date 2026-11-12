# Brightbox Kaleidoscope Workshop: shard tray index.
#
# Every shard of the kaleidoscope is listed in data/shards.json. Each resource below decodes the file and
# loops over it on its own, and the checksum is recomputed in three places. With the real catalogue
# (tens of thousands of shards) a plan spends most of its time doing this one job five times over.

resource "local_file" "north_index" {
  filename = "${path.module}/kaleidoscope/north.txt"
  content  = "${join("\n", sort([for t in jsondecode(file("${path.module}/data/shards.json")).shards : t.id if t.quadrant == "north"]))}\n"
}

resource "local_file" "south_index" {
  filename = "${path.module}/kaleidoscope/south.txt"
  content  = "${join("\n", sort([for t in jsondecode(file("${path.module}/data/shards.json")).shards : t.id if t.quadrant == "south"]))}\n"
}

resource "local_file" "east_index" {
  filename = "${path.module}/kaleidoscope/east.txt"
  content  = "${join("\n", sort([for t in jsondecode(file("${path.module}/data/shards.json")).shards : t.id if t.quadrant == "east"]))}\n"
}

resource "local_file" "west_index" {
  filename = "${path.module}/kaleidoscope/west.txt"
  content  = "${join("\n", sort([for t in jsondecode(file("${path.module}/data/shards.json")).shards : t.id if t.quadrant == "west"]))}\n"
}

resource "local_file" "summary" {
  filename = "${path.module}/kaleidoscope/summary.txt"
  content  = <<-EOT
    shards: ${length(jsondecode(file("${path.module}/data/shards.json")).shards)}
    megabytes: ${floor(sum([for t in jsondecode(file("${path.module}/data/shards.json")).shards : t.bytes]) / 1048576)}
    highest complexity: ${max([for t in jsondecode(file("${path.module}/data/shards.json")).shards : t.complexity]...)}
    checksum: ${sha256(jsonencode(jsondecode(file("${path.module}/data/shards.json")).shards))}
  EOT
}

resource "local_file" "audit_stamp" {
  filename = "${path.module}/kaleidoscope/audit.txt"
  content  = "audit ${sha256(jsonencode(jsondecode(file("${path.module}/data/shards.json")).shards))} over ${length(jsondecode(file("${path.module}/data/shards.json")).shards)} shards\n"
}

output "checksum" {
  value = sha256(jsonencode(jsondecode(file("${path.module}/data/shards.json")).shards))
}

output "quadrant_counts" {
  value = {
    for r in ["north", "south", "east", "west"] :
    r => length([for t in jsondecode(file("${path.module}/data/shards.json")).shards : t if t.quadrant == r])
  }
}
