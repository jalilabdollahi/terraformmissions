variable "sugarbush" {
  type = string
}

variable "season" {
  type    = string
  default = "unknown"
}

locals {
  label = "${var.sugarbush} syrup, season ${var.season}"
  slug  = replace(lower(var.sugarbush), " sugarbush", "")
}

resource "local_file" "tin_label" {
  filename = "${path.root}/syrup/${local.slug}-${var.season}.txt"
  content  = "${local.label}\n"
}

output "label" {
  value = local.label
}
