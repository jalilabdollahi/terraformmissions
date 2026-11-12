variable "name" {
  type = string
}

variable "hour" {
  type = number
}

locals {
  next_chime = format("%02d:00", (var.hour + 1) % 24)
  slug       = replace(lower(var.name), " ", "-")
}

resource "local_file" "roster" {
  filename = "${path.root}/chimes/${local.slug}.txt"
  content  = "${var.name} rings next at ${local.next_chime}\n"
}

output "next_chime" {
  value = local.next_chime
}

output "roster_file" {
  value = local_file.roster.filename
}
