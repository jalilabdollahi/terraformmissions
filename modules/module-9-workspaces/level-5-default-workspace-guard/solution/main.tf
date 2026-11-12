# Marlow carillon chime schedules: one workspace per tower. Never use "default".

locals {
  quarter_hours = ["07:15", "07:30", "07:45", "08:00"]
}

resource "local_file" "chimes" {
  filename = "${path.module}/out/${terraform.workspace}-chimes.txt"
  content  = "Tower ${terraform.workspace}\n${join("\n", local.quarter_hours)}\n"

  lifecycle {
    precondition {
      condition     = terraform.workspace != "default"
      error_message = "Refusing to schedule chimes from the default workspace. Select a tower workspace first."
    }
  }
}
