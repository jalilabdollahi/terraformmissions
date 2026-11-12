# Daily shift board for the Tinkertop toy factory.
# The floor manager prints everything under out/ and pins it beside the assembly line.

locals {
  builds = {
    teddy  = 24
    robot  = 12
    puzzle = 18
  }
  board_lines = [for name, qty in local.builds : "${format("%-10s", name)} x ${qty}"]
}

resource "local_file" "shift_board" {
  filename = "${path.module}/out/shift-board.txt"
  content  = "SHIFT BOARD\n${join("\n", local.board_lines)}\n"
}

resource "local_file" "pallet_labels" {
  filename = "${path.module}/out/pallet-labels.txt"
  content  = "teddy 4.50\nrobot 5.25\npuzzle 3.75\n"
}

output "shift_board_path" {
  value = local_file.shift_board.filename
}

output "total_toys" {
  value = sum(values(local.builds))
}
