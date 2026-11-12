# Pier Pavilion seaside arcade: cabinet tokens and cards.
# A big refactor landed in one commit (see NOTES.md for the three jobs). The code is
# already in its final shape, but nothing tells Terraform how the existing objects map
# onto it, so the plan wants to destroy and recreate almost everything.

variable "cabinets" {
  type    = list(string)
  default = ["skee-ball", "claw", "racer"]
}

resource "random_id" "token" {
  for_each    = toset(var.cabinets)
  byte_length = 3
}

resource "local_file" "cabinet_card" {
  for_each = toset(var.cabinets)
  filename = "${path.module}/cards/${each.key}.txt"
  content  = "cabinet ${each.key} token ${random_id.token[each.key].hex}\n"
}

resource "random_integer" "jackpot" {
  min = 1000
  max = 9999
}

output "jackpot" {
  value = random_integer.jackpot.result
}

moved {
  from = random_id.token[0]
  to   = random_id.token["skee-ball"]
}

moved {
  from = local_file.cabinet_card[0]
  to   = local_file.cabinet_card["skee-ball"]
}

moved {
  from = random_id.token[1]
  to   = random_id.token["claw"]
}

moved {
  from = local_file.cabinet_card[1]
  to   = local_file.cabinet_card["claw"]
}

moved {
  from = random_id.token[2]
  to   = random_id.token["racer"]
}

moved {
  from = local_file.cabinet_card[2]
  to   = local_file.cabinet_card["racer"]
}

# The gull mascot costume is already printed with its name: forget it, never destroy it.
removed {
  from = random_pet.mascot

  lifecycle {
    destroy = false
  }
}

# Jackpot number 7421 is already on the prize-board sign.
import {
  to = random_integer.jackpot
  id = "7421,1000,9999"
}
