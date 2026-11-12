# Build journal for the Crumbwell vintage motorbike restoration.
# The mechanic keeps personal notes in build-notes.txt. Terraform creates the file
# with a first line, and from then on the content is the mechanic's business, so
# Terraform must not overwrite it on later runs. The work schedule file,
# however, is managed by Terraform and must always match the config.

locals {
  shift_length_hours = 12
}

resource "local_file" "build_notes" {
  filename = "${path.module}/journal/build-notes.txt"
  content  = "Build day 1 - frame stripped and primed. Shift change every ${local.shift_length_hours}h.\n"

  lifecycle {
    ignore_changes = [contents, body]
  }
}

resource "local_file" "schedule" {
  filename = "${path.module}/journal/schedule.txt"
  content  = "Change shifts every ${local.shift_length_hours} hours.\n"
}
