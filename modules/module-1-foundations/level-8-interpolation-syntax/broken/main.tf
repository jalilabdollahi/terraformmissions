# Daily bulletin for the Kestrel Ridge weather station.
variable "station" {
  type    = string
  default = "Kestrel Ridge"
}

variable "altitude_m" {
  type    = number
  default = 1840
}

variable "wind_knots" {
  type    = number
  default = 23
}

resource "local_file" "bulletin" {
  filename = "${path.module}/weather/bulletin.txt"
  content  = "Station: $(var.station)\nAltitude: {var.altitude_m} m\nWind: ${var.wind_knots} knots\n"
}

output "bulletin_path" {
  value = local_file.bulletin.filename
}
