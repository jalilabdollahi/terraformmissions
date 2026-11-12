# Glasshouse climate controller config.
# `terraform apply` is run with no flags by the greenhouse's nightly job.
# The summer settings live in prod.tfvars; the nightly job should use them.

resource "local_file" "controller" {
  filename = "${path.module}/controller/settings.json"
  content = jsonencode({
    house   = var.greenhouse
    temp_c  = var.target_temp_c
    vents   = var.vent_mode
    misting = var.misting_per_day
  })
}

output "target_temp_c" {
  value = var.target_temp_c
}

output "vent_mode" {
  value = var.vent_mode
}

output "misting_per_day" {
  value = var.misting_per_day
}
