# Ballroom dance hall: the front desk reads the floor-staff team's published outputs to print the season programme.

data "terraform_remote_state" "staff" {
  backend = "local"

  config = {
    path = "${path.module}/floor-staff/terraform.tfstate"
  }
}

locals {
  plan   = data.terraform_remote_state.staff.outputs
  floors = local.plan.floor_plan
  couples  = sum([for s in local.floors : s.couples])
  caller = local.plan.staff_leads["calling"]
}

resource "local_file" "season_programme" {
  filename = "${path.module}/front-desk/season-programme.txt"
  content = join("\n", concat(
    ["${title(local.plan.season)} season", "Head caller: ${local.caller}"],
    [for name, s in local.floors : "${name}: ${s.couples} couples, ${s.mirrors} mirrors"],
    [""]
  ))
}

output "total_couples" {
  value = local.couples
}

output "head_caller" {
  value = local.caller
}
