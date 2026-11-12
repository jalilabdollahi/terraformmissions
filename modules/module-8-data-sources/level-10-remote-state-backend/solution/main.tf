# Route planning team: reads facts that the depot team publishes through their Terraform state.

data "terraform_remote_state" "depot" {
  backend = "local"

  config = {
    path = "${path.module}/depot-team/state/depot.tfstate"
  }
}

locals {
  depot = data.terraform_remote_state.depot.outputs
}

resource "local_file" "routes_header" {
  filename = "${path.module}/routes/header.txt"
  content  = "Depot ${local.depot.depot_code}: ${local.depot.bay_count} bays, first gritter ${local.depot.first_departure}\n"
}

output "header" {
  value = local_file.routes_header.content
}

output "depot_code" {
  value = local.depot.depot_code
}
