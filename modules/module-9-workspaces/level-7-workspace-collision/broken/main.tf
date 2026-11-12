# Pinewater youth camp: bunk roster and wake-up calls. One workspace per wing (east, west).

locals {
  wing_bunks = {
    east = 8
    west = 12
  }
  bunks = local.wing_bunks[terraform.workspace]
}

resource "local_file" "bunk_roster" {
  filename = "${path.module}/out/bunks.txt"
  content  = "Wing ${terraform.workspace}: ${local.bunks} bunks\n"
}

resource "local_file" "wake_calls" {
  filename = "${path.module}/out/wake-calls.txt"
  content  = "Wing ${terraform.workspace}: wake-up at 06:30 for the lake swim\n"
}
