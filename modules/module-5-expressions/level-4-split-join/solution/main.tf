# Waymark Society — signposts for the pilgrim trails.
# Volunteers type each trail's waypoints into one comma-separated string.

variable "trails" {
  type = map(string)
  default = {
    "Heron Way"  = "Oak Gate, Mill Ford,, Stone Cross,"
    "Quiet Loop" = ""
  }
}

locals {
  stops = {
    for trail, csv in var.trails :
    trail => [for s in split(",", csv) : trimspace(s) if trimspace(s) != ""]
  }
  signposts = {
    for trail, list in local.stops :
    trail => length(list) == 0 ? "closed for walkers" : join(" → ", list)
  }
}

resource "local_file" "signpost" {
  for_each = local.signposts
  filename = "${path.module}/signs/${replace(lower(each.key), " ", "-")}.txt"
  content  = "${each.key}: ${each.value}\n"
}

output "stop_counts" {
  value = { for trail, list in local.stops : trail => length(list) }
}

output "signposts" {
  value = local.signposts
}
