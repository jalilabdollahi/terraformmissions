# Karakul Solar Car Challenge Team: pit garage provisioning checklist.

resource "null_resource" "battery_pack" {
  triggers = {
    cells  = "24"
    refill = "day-5"
  }
}

resource "null_resource" "telemetry_schedule" {
  triggers = {
    window = "06:00-06:30 UTC"
  }
}
