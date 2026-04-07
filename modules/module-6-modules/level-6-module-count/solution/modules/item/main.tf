variable "name" {
  type        = string
  description = "Name for the file"
}

resource "local_file" "item" {
  content  = "item: ${var.name}"
  filename = "${path.module}/item-${var.name}.txt"
}
