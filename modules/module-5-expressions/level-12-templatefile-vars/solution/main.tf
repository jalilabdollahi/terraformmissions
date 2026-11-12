# Dunmore Telegraph Office — outgoing telegram form, rendered from a template file.

variable "station" {
  type    = string
  default = "dunmore"
}

variable "recipient" {
  type    = string
  default = "Capt. Hale, Harbour Master"
}

variable "sender" {
  type    = string
  default = "Office of the Postmaster"
}

variable "body" {
  type    = string
  default = "Packet boat delayed by fog arrives Thursday noon"
}

locals {
  telegram = templatefile("${path.module}/telegram.tpl", {
    station   = var.station
    recipient = var.recipient
    sender    = var.sender
    body      = var.body
  })
}

resource "local_file" "outbox" {
  filename = "${path.module}/outbox/telegram.txt"
  content  = local.telegram
}

output "telegram" {
  value = local.telegram
}
