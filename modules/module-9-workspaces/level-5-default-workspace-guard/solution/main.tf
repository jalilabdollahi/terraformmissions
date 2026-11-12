# Marlow city fountains: spray schedules, one workspace per fountain. Never use "default".

locals {
  quarter_hours = ["07:15", "07:30", "07:45", "08:00"]
}

resource "local_file" "sprays" {
  filename = "${path.module}/out/${terraform.workspace}-sprays.txt"
  content  = "Fountain ${terraform.workspace}\n${join("\n", local.quarter_hours)}\n"

  lifecycle {
    precondition {
      condition     = terraform.workspace != "default"
      error_message = "Refusing to schedule sprays from the default workspace. Select a fountain workspace first."
    }
  }
}
