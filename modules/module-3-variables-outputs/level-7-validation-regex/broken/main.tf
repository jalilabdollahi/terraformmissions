# Aurelia Opera House — season ticket codes.
# A code looks like ORC-2041: three capital letters, a hyphen, four digits.
# The box office pastes codes into this config; the validation is meant to
# reject anything that is not shaped like that.

variable "ticket_code" {
  description = "Season ticket code, e.g. ORC-2041."
  type        = string
  default     = "ORC-2041"

  validation {
    condition     = can(regex("^[A-Z]{3}[0-9]{4}$", var.ticket_code))
    error_message = "Ticket codes look like ORC-2041: three capital letters, a hyphen, four digits."
  }
}

locals {
  section = split("-", var.ticket_code)[0]
  seat_id = tonumber(split("-", var.ticket_code)[1])
}

resource "local_file" "stub" {
  filename = "${path.module}/stubs/${var.ticket_code}.txt"
  content  = "Section ${local.section}, seat ${local.seat_id}\n"
}

output "section" {
  value = local.section
}

output "seat_id" {
  value = local.seat_id
}
