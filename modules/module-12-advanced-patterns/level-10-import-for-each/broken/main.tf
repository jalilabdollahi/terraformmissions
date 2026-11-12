# Spoke & Sprocket bike repair: job ticket numbers.
# Four jobs already have paper tickets in the shop (see var.legacy_tickets, written as
# "number,min,max" which is the import ID format of random_integer). The old shop software
# is retired, so every ticket has to be adopted. Only the first one made it into the code.

variable "legacy_tickets" {
  type = map(string)
  default = {
    frame  = "4021,1000,9999"
    wheels = "7316,1000,9999"
    brakes = "2288,1000,9999"
    chain  = "5907,1000,9999"
  }
}

resource "random_pet" "mechanic" {
  length = 2
  prefix = "mech"
}

resource "random_integer" "ticket" {
  for_each = var.legacy_tickets
  min      = 1000
  max      = 9999
}

import {
  to = random_integer.ticket["frame"]
  id = var.legacy_tickets["frame"]
}

resource "local_file" "board" {
  filename = "${path.module}/shop/board.txt"
  content = join("\n", concat(
    ["on shift: ${random_pet.mechanic.id}"],
    [for job in sort(keys(random_integer.ticket)) : "${job}: #${random_integer.ticket[job].result}"],
    [""]
  ))
}
