# Halcyon - warehouse stack (new home of the dock and floats).

resource "random_id" "dock_key" {
  byte_length = 4
}

resource "random_integer" "rider_capacity" {
  min = 180
  max = 640
}

resource "random_id" "float_serial" {
  for_each    = toset(["main", "annex"])
  byte_length = 3
}

output "dock_key" {
  value = random_id.dock_key.hex
}

output "rider_capacity" {
  value = random_integer.rider_capacity.result
}
