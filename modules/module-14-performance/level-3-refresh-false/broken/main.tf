# Halvorsen Lab freezer setpoints, one file per unit.

variable "freezers" {
  type = map(number)
  default = {
    "ice-core-a" = -80
    "ice-core-b" = -80
    "plasma-c"   = -40
    "reagent-d"  = -20
  }
}

resource "local_file" "freezer" {
  for_each = var.freezers
  filename = "${path.module}/freezer/${each.key}.txt"
  content  = "${each.key} setpoint ${each.value}C\n"
}

output "freezer_count" {
  value = length(local_file.freezer)
}
