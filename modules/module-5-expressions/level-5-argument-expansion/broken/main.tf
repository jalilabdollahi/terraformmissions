# Kallavik Ice Station — core drilling log.
# Each drill site reports the depths (in metres) at which it sampled ice.

variable "cores" {
  type = map(list(number))
  default = {
    "Camp Ridge" = [12.5, 48, 31.2, 7.75]
    "North Col"  = [60.4, 22]
    "Blue Pass"  = [15, 15.5, 90.25]
  }
}

locals {
  all_depths  = flatten(values(var.cores))
  deepest     = max(local.all_depths)
  shallowest  = min(local.all_depths)
  site_deepest = { for site, depths in var.cores : site => max(depths) }
}

resource "local_file" "log_summary" {
  filename = "${path.module}/log/summary.txt"
  content  = "samples=${length(local.all_depths)} deepest=${local.deepest}m shallowest=${local.shallowest}m\n"
}

output "deepest_m" {
  value = local.deepest
}

output "shallowest_m" {
  value = local.shallowest
}

output "span_m" {
  value = local.deepest - local.shallowest
}

output "site_deepest_m" {
  value = local.site_deepest
}
