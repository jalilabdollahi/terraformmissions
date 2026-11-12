# Harrow Farm grain co-op: shift report for silo 4.
# The temperature sensor's status lives in silo/status.txt (written by another system).
# The farm wants to be NOTIFIED when the sensor is not "ok", but the shift report must
# be written every shift regardless. Right now a degraded sensor blocks the whole apply.

data "local_file" "sensor" {
  filename = "${path.module}/silo/status.txt"
}

resource "local_file" "shift_report" {
  filename = "${path.module}/reports/silo-4-shift.txt"
  content  = "silo 4 shift report: intake logged\n"

  lifecycle {
    precondition {
      condition     = trimspace(data.local_file.sensor.content) == "ok"
      error_message = "Silo 4 temperature sensor is not reporting ok."
    }
  }
}
