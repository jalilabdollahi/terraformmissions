# Steelpan tuning yard: the tuning sheet is kept as a plain text file next to this config.

data "local_file" "tuning_sheet" {
  filename = "${path.module}/sheets/tenor-lead.txt"
}

locals {
  sheet_lines = split("\n", trimspace(data.local_file.tuning_sheet.content))
  pan_name   = trimspace(split(":", local.sheet_lines[0])[1])
  note_count  = tonumber(regex("notes: ([0-9]+)", data.local_file.tuning_sheet.content)[0])
}

resource "local_file" "pan_card" {
  filename = "${path.module}/out/pan-card.txt"
  content  = "Pan card\nPan: ${local.pan_name}\nNotes to tune: ${local.note_count}\n"
}

output "pan_name" {
  value = local.pan_name
}

output "note_count" {
  value = local.note_count
}
