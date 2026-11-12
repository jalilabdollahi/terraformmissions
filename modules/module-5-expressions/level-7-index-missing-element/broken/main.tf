# St Aldhelm's bell tower — the order a peal is rung in.
# The ringing master names the bell to start on; the rest follow in tower order, wrapping round.

variable "bells" {
  type    = list(string)
  default = ["Gabriel", "Mary", "Peter", "Thomas", "John"]
}

variable "start_bell" {
  type    = string
  default = "Michael"
}

locals {
  start_index = index(var.bells, var.start_bell)
  ringing_order = concat(
    slice(var.bells, local.start_index, length(var.bells)),
    slice(var.bells, 0, local.start_index),
  )
}

resource "local_file" "peal_sheet" {
  filename = "${path.module}/sheets/peal.txt"
  content  = "${join(" > ", local.ringing_order)}\n"
}

output "start_index" {
  value = local.start_index
}

output "ringing_order" {
  value = local.ringing_order
}
