# Millbrook Water Treatment Plant: shift report for clarifier 4.
# The turbidity sensor's status lives in clarifier/status.txt (written by another system).
# The plant wants to be NOTIFIED when the sensor is not "ok", but the shift report must
# be written every shift regardless. Right now a degraded sensor blocks the whole apply.

data "local_file" "sensor" {
  filename = "${path.module}/clarifier/status.txt"
}

resource "local_file" "shift_report" {
  filename = "${path.module}/reports/clarifier-4-shift.txt"
  content  = "clarifier 4 shift report: intake logged\n"

  lifecycle {
    precondition {
      condition     = trimspace(data.local_file.sensor.content) == "ok"
      error_message = "Clarifier 4 turbidity sensor is not reporting ok."
    }
  }
}
