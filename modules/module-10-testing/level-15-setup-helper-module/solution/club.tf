variable "lineup_path" {
  description = "Path of the JSON act lineup."
  type        = string
}

data "local_file" "lineup" {
  filename = var.lineup_path
}

locals {
  acts = jsondecode(data.local_file.lineup.content).acts
}

output "act_count" {
  value = length(local.acts)
}

output "total_minutes" {
  value = sum([for r in local.acts : r.minutes])
}

output "needs_intermission" {
  value = sum([for r in local.acts : r.minutes]) > 120
}
