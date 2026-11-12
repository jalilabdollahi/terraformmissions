# Ridgeline weather station — daily status line for the mountain hut board.
# A reading is a fixed-position tuple: [station id, temperature in C, online?]

variable "latest_reading" {
  description = "[station id, temperature in degrees C, is the sensor online]"
  type        = tuple([string, number, bool])
  default     = ["north-ridge", 18.5, true]
}

locals {
  station_id = var.latest_reading[0]
  temp_c     = var.latest_reading[1]
  online     = var.latest_reading[2]
}

resource "local_file" "hut_board" {
  filename = "${path.module}/board/status.txt"
  content  = "${local.station_id}: ${local.temp_c} C, sensor ${local.online ? "online" : "OFFLINE"}\n"
}

output "station_id" {
  value = local.station_id
}

output "temp_c" {
  value = local.temp_c
}

output "online" {
  value = local.online
}
