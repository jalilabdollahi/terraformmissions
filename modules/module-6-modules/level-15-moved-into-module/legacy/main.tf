resource "random_id" "ticket" {
  byte_length = 4
  prefix      = "BLR-"
}

resource "local_file" "manifest" {
  filename = "${path.module}/shed/manifest.txt"
  content  = "boiler ticket ${random_id.ticket.hex}\n"
}

output "ticket" {
  value = random_id.ticket.hex
}
