variable "callsign" { type = string }
resource "random_id" "beacon" {
  byte_length = 4
  keepers     = { id = var.callsign }
}
resource "local_file" "beacon_sheet" {
  filename = "${path.root}/stations/${lower(var.callsign)}.txt"
  content  = "${var.callsign} beacon ${random_id.beacon.hex}\n"
}
output "beacon_serial" { value = random_id.beacon.hex }
