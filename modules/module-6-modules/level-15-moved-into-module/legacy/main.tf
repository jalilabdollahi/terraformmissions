resource "random_id" "ticket" {
  byte_length = 4
  prefix      = "ZEP-"
}

resource "local_file" "manifest" {
  filename = "${path.module}/hangar/manifest.txt"
  content  = "mooring ticket ${random_id.ticket.hex}\n"
}

output "ticket" {
  value = random_id.ticket.hex
}
