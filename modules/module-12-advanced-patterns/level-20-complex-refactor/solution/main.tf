# Bounce Hollow trampoline park: court wristbands and cards.
# A big refactor landed in one commit (see NOTES.md for the three jobs). The code is
# already in its final shape, but nothing tells Terraform how the existing objects map
# onto it, so the plan wants to destroy and recreate almost everything.

variable "courts" {
  type    = list(string)
  default = ["freestyle", "dodgeball", "ninja"]
}

resource "random_id" "band" {
  for_each    = toset(var.courts)
  byte_length = 3
}

resource "local_file" "court_card" {
  for_each = toset(var.courts)
  filename = "${path.module}/cards/${each.key}.txt"
  content  = "court ${each.key} band ${random_id.band[each.key].hex}\n"
}

resource "random_integer" "highscore" {
  min = 1000
  max = 9999
}

output "highscore" {
  value = random_integer.highscore.result
}

moved {
  from = random_id.band[0]
  to   = random_id.band["freestyle"]
}

moved {
  from = local_file.court_card[0]
  to   = local_file.court_card["freestyle"]
}

moved {
  from = random_id.band[1]
  to   = random_id.band["dodgeball"]
}

moved {
  from = local_file.court_card[1]
  to   = local_file.court_card["dodgeball"]
}

moved {
  from = random_id.band[2]
  to   = random_id.band["ninja"]
}

moved {
  from = local_file.court_card[2]
  to   = local_file.court_card["ninja"]
}

# The kangaroo mascot costume is already printed with its name: forget it, never destroy it.
removed {
  from = random_pet.mascot

  lifecycle {
    destroy = false
  }
}

# High score 7421 is already on the scoreboard sign.
import {
  to = random_integer.highscore
  id = "7421,1000,9999"
}
