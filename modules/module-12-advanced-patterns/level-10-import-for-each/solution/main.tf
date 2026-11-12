# Saltwater Shapers surfboard workshop: job ticket numbers.
# Four jobs already have paper tickets in the workshop (see var.legacy_tickets, written as
# "number,min,max" which is the import ID format of random_integer). The old workshop software
# is retired, so every ticket has to be adopted. Only the first one made it into the code.

variable "legacy_tickets" {
  type = map(string)
  default = {
    longboard  = "4021,1000,9999"
    shortboard = "7316,1000,9999"
    fish       = "2288,1000,9999"
    gun        = "5907,1000,9999"
  }
}

resource "random_pet" "shaper" {
  length = 2
  prefix = "shaper"
}

resource "random_integer" "ticket" {
  for_each = var.legacy_tickets
  min      = 1000
  max      = 9999
}

import {
  for_each = var.legacy_tickets
  to       = random_integer.ticket[each.key]
  id       = each.value
}

resource "local_file" "queue" {
  filename = "${path.module}/shop/queue.txt"
  content = join("\n", concat(
    ["on shift: ${random_pet.shaper.id}"],
    [for job in sort(keys(random_integer.ticket)) : "${job}: #${random_integer.ticket[job].result}"],
    [""]
  ))
}
