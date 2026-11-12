# Submarine Kittiwake — crew roster generated from the boat's YAML config.

variable "config_path" {
  type    = string
  default = "config.yaml"
}

locals {
  cfg  = yamldecode(file(var.config_path))
  boat = local.cfg.submarine.name
  crew = local.cfg.crew
  lines = [
    for i in local.crew :
    format("%s manual %s lang %s", i.name, i.manual, i.language)
  ]
}

resource "local_file" "roster" {
  filename = "${path.module}/roster/crew.txt"
  content  = "${local.boat}\n${join("\n", local.lines)}\n"
}

output "boat" {
  value = local.boat
}

output "lines" {
  value = local.lines
}

output "on_watch_count" {
  value = length([for i in local.crew : i if i.on_watch])
}
