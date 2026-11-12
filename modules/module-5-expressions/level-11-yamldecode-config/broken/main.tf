# Skerry Head Observatory — instrument roster generated from the observatory's YAML config.

variable "config_path" {
  type    = string
  default = "config.yaml"
}

locals {
  cfg         = yamldecode(file(var.config_path))
  site        = local.cfg.observatory.name
  instruments = local.cfg.instruments
  lines = [
    for i in local.instruments :
    format("%s fw %s lang %s", i.name, i.firmware, i.language)
  ]
}

resource "local_file" "roster" {
  filename = "${path.module}/roster/instruments.txt"
  content  = "${local.site}\n${join("\n", local.lines)}\n"
}

output "site" {
  value = local.site
}

output "lines" {
  value = local.lines
}

output "enabled_count" {
  value = length([for i in local.instruments : i if i.enabled])
}
