# Port of Alderney: berth allocation board.
# The berth number was drawn once by an earlier run and is painted on the quay.
# imports.tf adopts it into this configuration, but it does not work yet.

resource "random_integer" "berth_number" {
  min = 100
  max = 999
}

resource "local_file" "berth_board" {
  filename = "${path.module}/harbour/berth-board.txt"
  content  = "Cargo vessel moors at berth ${random_integer.berth_number.result}\n"
}
