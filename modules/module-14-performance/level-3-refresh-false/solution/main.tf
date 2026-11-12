# Greenfield Market chilled-aisle setpoints, one file per unit.

variable "chillers" {
  type = map(number)
  default = {
    "yoghurt-a" = 2
    "yoghurt-b" = 2
    "salad-c"   = 4
    "deli-d"    = 5
  }
}

resource "local_file" "chiller" {
  for_each = var.chillers
  filename = "${path.module}/chiller/${each.key}.txt"
  content  = "${each.key} setpoint ${each.value}C\n"
}

output "chiller_count" {
  value = length(local_file.chiller)
}
