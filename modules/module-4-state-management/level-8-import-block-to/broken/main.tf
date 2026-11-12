# Alderney Halls: room allocation board.
# The room number was drawn once by an earlier run and is painted on the door.
# imports.tf adopts it into this configuration, but it does not work yet.

resource "random_integer" "room_number" {
  min = 100
  max = 999
}

resource "local_file" "room_board" {
  filename = "${path.module}/halls/room-board.txt"
  content  = "First-year student moves into room ${random_integer.room_number.result}\n"
}
