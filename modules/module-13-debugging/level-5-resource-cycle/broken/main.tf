# Weekly evening patrol for the Elmwood Neighbourhood Watch.

locals {
  patrol_name = "Elmwood Tuesday Patrol"
}

# The roster must prove it belongs to the current schedule by quoting the schedule's checksum.
resource "local_file" "patrol_roster" {
  filename = "${path.module}/patrol/roster.txt"
  content  = <<-EOT
    ${local.patrol_name} - roster
    schedule checksum: ${local_file.patrol_schedule.content_sha256}
    patrol lead: Mrs Okafor
    walkers: Ana, Ben, Chidi
  EOT
}

# The schedule tells walkers where to find the roster.
resource "local_file" "patrol_schedule" {
  filename = "${path.module}/patrol/schedule.txt"
  content  = <<-EOT
    ${local.patrol_name} - schedule
    roster file: ${local_file.patrol_roster.filename}
    20:00 patrol lead briefs the walkers at the Elm Street gate
    20:30 patrol sets out
  EOT
}

output "roster_checksum_line" {
  value = element(split("\n", local_file.patrol_roster.content), 1)
}
