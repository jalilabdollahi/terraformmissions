# Weekly 2-metre net for the Brookfield amateur radio club.

locals {
  net_name = "Brookfield Tuesday Net"
}

# The roster must prove it belongs to the current schedule by quoting the schedule's checksum.
resource "local_file" "net_roster" {
  filename = "${path.module}/net/roster.txt"
  content  = <<-EOT
    ${local.net_name} - roster
    schedule checksum: ${local_file.net_schedule.content_sha256}
    net control: K9BRK
    check-ins: W9ABC, N9XYZ, KD9QRS
  EOT
}

# The schedule tells operators where to find the roster.
resource "local_file" "net_schedule" {
  filename = "${path.module}/net/schedule.txt"
  content  = <<-EOT
    ${local.net_name} - schedule
    roster file: ${local_file.net_roster.filename}
    20:00 net control calls the net on 145.230 MHz
    20:30 open floor
  EOT
}

output "roster_checksum_line" {
  value = element(split("\n", local_file.net_roster.content), 1)
}
