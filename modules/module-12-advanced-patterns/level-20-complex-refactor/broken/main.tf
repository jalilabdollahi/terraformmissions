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
