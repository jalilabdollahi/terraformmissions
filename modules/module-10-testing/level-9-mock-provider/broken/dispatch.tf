resource "random_id" "ticket" {
  byte_length = 4
}

resource "random_integer" "zone" {
  min = 1
  max = 6
}

output "ticket" {
  value = "WC-${upper(random_id.ticket.hex)}"
}

output "dispatch_zone" {
  value = "zone-${random_integer.zone.result}"
}
