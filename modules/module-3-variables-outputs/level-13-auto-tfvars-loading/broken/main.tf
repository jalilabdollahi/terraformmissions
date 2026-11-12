# Sauna heater controller config.
# `terraform apply` is run with no flags by the spa's nightly job.
# The winter settings live in prod.tfvars; the nightly job should use them.

resource "local_file" "controller" {
  filename = "${path.module}/controller/settings.json"
  content = jsonencode({
    room   = var.spa_room
    temp_c = var.target_temp_c
    vents  = var.vent_mode
    steam  = var.steam_per_day
  })
}

output "target_temp_c" {
  value = var.target_temp_c
}

output "vent_mode" {
  value = var.vent_mode
}

output "steam_per_day" {
  value = var.steam_per_day
}
