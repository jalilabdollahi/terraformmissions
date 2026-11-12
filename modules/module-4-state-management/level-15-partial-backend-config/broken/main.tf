# Highland Radio: Signal Tower beacon.
# The backend location is NOT in terraform.tf; it comes from
# config/backend-prod.hcl at init time.

resource "random_pet" "callsign" {
  length    = 2
  separator = "-"
  prefix    = "hl"
}

resource "random_integer" "frequency_khz" {
  min = 88000
  max = 107900
}

resource "local_file" "beacon" {
  filename = "${path.module}/beacon/signal.txt"
  content  = "Station ${random_pet.callsign.id} broadcasting on ${random_integer.frequency_khz.result} kHz\n"
}
