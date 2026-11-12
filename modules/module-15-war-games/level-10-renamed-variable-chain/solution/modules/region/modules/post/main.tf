variable "radio_id" {
  type = string
}

resource "random_id" "beacon" {
  byte_length = 4

  keepers = {
    id = var.radio_id
  }
}

resource "local_file" "beacon_sheet" {
  filename = "${path.root}/stations/${lower(var.radio_id)}.txt"
  content  = "${var.radio_id} beacon ${random_id.beacon.hex}\n"
}

output "beacon_serial" {
  value = random_id.beacon.hex
}
