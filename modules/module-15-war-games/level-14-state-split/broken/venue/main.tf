# Halcyon - venue stack (new home of the hall and stages).

resource "random_id" "hall_key" {
  byte_length = 4
}

resource "random_integer" "seat_capacity" {
  min = 180
  max = 640
}

resource "random_id" "stage_serial" {
  for_each    = toset(["main", "annex"])
  byte_length = 3
}

output "hall_key" {
  value = random_id.hall_key.hex
}

output "seat_capacity" {
  value = random_integer.seat_capacity.result
}
