# Timetable team: reads facts that the depot team publishes through their Terraform state.

data "terraform_remote_state" "depot" {
  backend = "local"

  config = {
    path = "${path.module}/depot-team/state/depot.tfstate"
  }
}

locals {
  depot = data.terraform_remote_state.depot.outputs
}

resource "local_file" "timetable_header" {
  filename = "${path.module}/timetable/header.txt"
  content  = "Depot ${local.depot.depot_code}: ${local.depot.bay_count} bays, first bus ${local.depot.first_departure}\n"
}

output "header" {
  value = local_file.timetable_header.content
}

output "depot_code" {
  value = local.depot.depot_code
}
