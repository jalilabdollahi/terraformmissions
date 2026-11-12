# Table reservations at the Dicewood board-game cafe.
# Each walk-in group is given a themed table name and a seat number; the
# host stand prints both on the reservation slip.

resource "random_pet" "table" {
  prefix = "table"
  length = 1
}

resource "random_integer" "seat" {
  min = 1
  max = 8
}

resource "local_file" "reservation_slip" {
  filename = "${path.module}/hoststand/slip.txt"
  content  = "Your table: ${random_pet.table.id}, seat ${random_integer.seat.result}\n"
}

output "table_name" {
  value = random_pet.table.id
}

output "seat_number" {
  value = random_integer.seat.result
}
