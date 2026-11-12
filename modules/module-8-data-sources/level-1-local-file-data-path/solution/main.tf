# Pipe-organ voicing: the tuning sheet is kept as a plain text file next to this config.

data "local_file" "tuning_sheet" {
  filename = "${path.module}/sheets/principal-8.txt"
}

locals {
  sheet_lines = split("\n", trimspace(data.local_file.tuning_sheet.content))
  stop_name   = trimspace(split(":", local.sheet_lines[0])[1])
  pipe_count  = tonumber(regex("pipes: ([0-9]+)", data.local_file.tuning_sheet.content)[0])
}

resource "local_file" "chest_card" {
  filename = "${path.module}/out/chest-card.txt"
  content  = "Wind chest card\nStop: ${local.stop_name}\nPipes to voice: ${local.pipe_count}\n"
}

output "stop_name" {
  value = local.stop_name
}

output "pipe_count" {
  value = local.pipe_count
}
