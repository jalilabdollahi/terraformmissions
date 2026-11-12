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
