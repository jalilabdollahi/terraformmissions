# Seed vault label for the Alder Hollow community seed library.
variable "lot" {
  type    = string
  default = "BEAN-2031"
}

variable "inspector" {
  description = "Who last checked the packets; changes weekly"
  type        = string
  default     = "M. Okafor"
}

# The label is printed once per lot. Weekly inspector changes must NOT
# trigger a rewrite of the label file, so content changes are ignored
# after creation.
resource "local_file" "seed_label" {
  filename = "${path.module}/vault/label-${var.lot}.txt"
  content  = "Seed lot: ${var.lot}\nLast inspected by: ${var.inspector}\n"

  lifecycle {
    ignore_changes = [content]
  }
}

output "label_file" {
  value = local_file.seed_label.filename
}
