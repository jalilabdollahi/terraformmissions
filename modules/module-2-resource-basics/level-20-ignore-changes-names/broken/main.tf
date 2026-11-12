# Feeding journal for the Crumbwell sourdough starter.
# The baker keeps personal notes in starter-notes.txt. Terraform creates the file
# with a first line, and from then on the content is the baker's business, so
# Terraform must not overwrite it on later runs. The feeding schedule file,
# however, is managed by Terraform and must always match the config.

locals {
  feeding_every_hours = 12
}

resource "local_file" "starter_notes" {
  filename = "${path.module}/journal/starter-notes.txt"
  content  = "Starter day 1 - bubbly and sweet-smelling. Feed 1:5:5 at ${local.feeding_every_hours}h.\n"

  lifecycle {
    ignore_changes = [contents, body]
  }
}

resource "local_file" "schedule" {
  filename = "${path.module}/journal/schedule.txt"
  content  = "Feed the starter every ${local.feeding_every_hours} hours.\n"
}
