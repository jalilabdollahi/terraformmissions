# Room bookings for the Nightowl Hackathon.
# Every room is booked on every day: one booking sheet per pair.

locals {
  room_days = {
    for pair in setproduct(var.rooms, var.days) :
    "${pair[0]}/${pair[1]}" => { room = pair[0], day = pair[1] }
  }
}

resource "local_file" "booking" {
  for_each = local.room_days
  filename = "${path.module}/bookings/${each.value.room}-${each.value.day}.txt"
  content  = "Room ${each.value.room} is booked for the hackers on ${each.value.day}.\n"
}

output "booking_count" {
  value = length(local_file.booking)
}
