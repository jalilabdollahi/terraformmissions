variable "label" {
  type = string
}

resource "local_file" "item" {
  content  = "label=${var.label}"
  filename = "${path.module}/item-${var.label}.txt"
}
