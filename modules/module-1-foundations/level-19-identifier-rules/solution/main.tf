# Spool labels for the Brightwell makerspace filament shelf.
variable "spool_colour" {
  type    = string
  default = "signal orange"
}

resource "local_file" "label_3d" {
  filename = "${path.module}/shelf/label.txt"
  content  = "PLA spool: ${var.spool_colour}\nDiameter: 1.75 mm\n"
}

resource "local_file" "spool_tag" {
  filename = "${path.module}/shelf/tag.txt"
  content  = "Reorder when below 200 g (${var.spool_colour})\n"
}

output "label_path" {
  value = local_file.label_3d.filename
}

output "tag_path" {
  value = local_file.spool_tag.filename
}
