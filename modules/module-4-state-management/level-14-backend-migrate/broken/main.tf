# Lakeland tourist-information kiosk network: kiosk configuration.
# The backend path in terraform.tf was updated to the new layout (vault/...),
# but the state still sits at the old path (state/kiosks.tfstate).

resource "random_id" "kiosk_serial" {
  byte_length = 4
  prefix      = "TI-"
}

resource "random_integer" "refresh_interval" {
  min = 5
  max = 30
}

resource "local_file" "kiosk_config" {
  filename = "${path.module}/config/kiosk.conf"
  content  = "serial=${random_id.kiosk_serial.hex}\nrefresh_every_minutes=${random_integer.refresh_interval.result}\n"
}
