# Cinder Valley Fire Service — which lookout towers go on tonight's watch roster.
# A tower qualifies when a ranger is posted there and it is tall enough to see over the canopy.

variable "towers" {
  type = list(object({
    name     = string
    height_m = number
    staffed  = bool
  }))
  default = [
    { name = "Raven Knob", height_m = 31, staffed = true },
    { name = "Ash Gap", height_m = 18, staffed = true },
    { name = "Tamarack", height_m = 25, staffed = true },
    { name = "Old Hollow", height_m = 40, staffed = false },
    { name = "Grey Rock", height_m = 27.5, staffed = true },
  ]
}

variable "min_height_m" {
  type    = number
  default = 25
}

locals {
  on_watch = [
    for t in var.towers : t
    if t.staffed && t.height_m >= var.min_height_m
  ]
}

resource "local_file" "roster" {
  filename = "${path.module}/rosters/tonight.txt"
  content  = "${join("\n", [for t in local.on_watch : "${t.name} (${t.height_m} m)"])}\n"
}

output "watch_list" {
  value = [for t in local.on_watch : t.name]
}

output "watch_heights" {
  value = { for t in local.on_watch : t.name => t.height_m }
}
