# Halcyon - ticketing stack (new home of bookings and passes).

data "terraform_remote_state" "venue" {
  backend = "local"
  config = {
    path = "${path.module}/../venue/terraform.tfstate"
  }
}

resource "random_uuid" "booking_ns" {}

resource "random_integer" "pass_series" {
  for_each = toset(["gold", "silver"])
  min      = 10000
  max      = 99999
}

resource "local_file" "ticket_book" {
  filename = "${path.module}/../out/ticket-book.txt"
  content  = "booking ${random_uuid.booking_ns.result}\nhall ${data.terraform_remote_state.venue.outputs.hall_key}\nseats ${data.terraform_remote_state.venue.outputs.seat_capacity}\ngold ${random_integer.pass_series["gold"].result} silver ${random_integer.pass_series["silver"].result}\n"
}

output "gold_series" {
  value = random_integer.pass_series["gold"].result
}
