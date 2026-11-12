# Rehearsal bookings for the Larkspur Choir Festival.
# Every rehearsal room is booked on every rehearsal day: one booking sheet per pair.

locals {
  room_days = setproduct(var.rooms, var.days)
}

resource "local_file" "booking" {
  for_each = local.room_days
  filename = "${path.module}/bookings/${each.value.room}-${each.value.day}.txt"
  content  = "Room ${each.value.room} is booked for the choir on ${each.value.day}.\n"
}

output "booking_count" {
  value = length(local_file.booking)
}
