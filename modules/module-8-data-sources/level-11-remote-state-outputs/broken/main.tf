# Puppet theatre: the box office reads the stage-crew team's published outputs to print the season bill.

data "terraform_remote_state" "crew" {
  backend = "local"

  config = {
    path = "${path.module}/stage-crew/terraform.tfstate"
  }
}

locals {
  plan   = data.terraform_remote_state.crew.outputs
  stages = local.plan.stage_plan
  seats  = sum([for s in local.stages : s.seats])
  rigger = local.plan.crew_leads["rigging"]
}

resource "local_file" "season_bill" {
  filename = "${path.module}/box-office/season-bill.txt"
  content = join("\n", concat(
    ["${title(local.plan.season)} season", "Head rigger: ${local.rigger}"],
    [for name, s in local.stages : "${name}: ${s.seats} seats, ${s.fly_bars} fly bars"],
    [""]
  ))
}

output "total_seats" {
  value = local.seats
}

output "head_rigger" {
  value = local.rigger
}
