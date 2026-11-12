# North Sea buoy network: station configuration.
# The backend path in terraform.tf was updated to the new layout (vault/...),
# but the state still sits at the old path (state/buoys.tfstate).

resource "random_id" "buoy_serial" {
  byte_length = 4
  prefix      = "NS-"
}

resource "random_integer" "sampling_interval" {
  min = 5
  max = 30
}

resource "local_file" "buoy_config" {
  filename = "${path.module}/config/buoy.conf"
  content  = "serial=${random_id.buoy_serial.hex}\nsample_every_minutes=${random_integer.sampling_interval.result}\n"
}
