variable "name" {
  type = string
}

variable "hour" {
  type = number
}

locals {
  next_call = format("%02d:00", (var.hour + 1) % 24)
  slug      = replace(lower(var.name), " ", "-")
}

resource "local_file" "roster" {
  filename = "${path.root}/calls/${local.slug}.txt"
  content  = "${var.name} calls next at ${local.next_call}\n"
}
