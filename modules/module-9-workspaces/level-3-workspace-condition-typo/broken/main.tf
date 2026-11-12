# Saltmarsh hatchery tank monitoring. Production keeps 90 days of logs and pages on-call.

locals {
  is_prod        = terraform.workspace == "prd"
  retention_days = local.is_prod ? 90 : 7
}

resource "local_file" "tank_log" {
  filename = "${path.module}/out/${terraform.workspace}-tank-log.txt"
  content  = "retention_days=${local.retention_days}\n"
}

resource "local_file" "pager_roster" {
  count    = local.is_prod ? 1 : 0
  filename = "${path.module}/out/pager-roster.txt"
  content  = "on-call: night shift, harbour office\n"
}

output "retention_days" {
  value = local.retention_days
}

output "pager_enabled" {
  value = local.is_prod
}
