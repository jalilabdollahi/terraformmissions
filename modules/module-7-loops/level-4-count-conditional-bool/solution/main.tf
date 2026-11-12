# Eastbank skatepark: opening notice plus an optional floodlight schedule.

resource "local_file" "park_notice" {
  filename = "${path.module}/notices/park.txt"
  content  = "Eastbank Skatepark - floodlights tonight: ${var.floodlights ? "ON" : "OFF"}\n"
}

resource "local_file" "floodlight_schedule" {
  count    = var.floodlights ? 1 : 0
  filename = "${path.module}/notices/floodlights.txt"
  content  = "Floodlights burn from dusk until 22:00.\n"
}

output "lights_on" {
  value = var.floodlights
}
