# Spool labels for the Brightwell makerspace filament shelf.
variable "spool colour" {
  type    = string
  default = "signal orange"
}

resource "local_file" "3d_label" {
  filename = "${path.module}/shelf/label.txt"
  content  = "PLA spool: ${var.spool colour}\nDiameter: 1.75 mm\n"
}

resource "local_file" "spool.tag" {
  filename = "${path.module}/shelf/tag.txt"
  content  = "Reorder when below 200 g (${var.spool colour})\n"
}

output "label_path" {
  value = local_file.3d_label.filename
}

output "tag_path" {
  value = local_file.spool.tag.filename
}
