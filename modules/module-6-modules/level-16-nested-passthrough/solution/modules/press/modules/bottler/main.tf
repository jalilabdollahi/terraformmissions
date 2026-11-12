variable "orchard" {
  type = string
}

variable "vintage" {
  type    = string
  default = "unknown"
}

locals {
  label = "${var.orchard} cider, vintage ${var.vintage}"
  slug  = replace(lower(var.orchard), " orchard", "")
}

resource "local_file" "bottle_label" {
  filename = "${path.root}/cider/${local.slug}-${var.vintage}.txt"
  content  = "${local.label}\n"
}

output "label" {
  value = local.label
}
