# Kaiten Corner sushi bar — which plates are announced on which conveyor belt.

variable "plates" {
  type = list(object({
    plate = string
    belt  = string
  }))
  default = [
    { plate = "TUNA-1", belt = "B1" },
    { plate = "EEL-1", belt = "B2" },
    { plate = "TUNA-2", belt = "B1" },
    { plate = "ROE-1", belt = "B3" },
    { plate = "EEL-2", belt = "B2" },
    { plate = "TUNA-3", belt = "B1" },
  ]
}

locals {
  by_belt = { for a in var.plates : a.belt => a.plate }
}

resource "local_file" "belt_board" {
  for_each = local.by_belt
  filename = "${path.module}/boards/${lower(each.key)}.txt"
  content  = "Belt ${each.key}: ${join(", ", each.value)}\n"
}

output "by_belt" {
  value = local.by_belt
}

output "load" {
  value = { for belt, plates in local.by_belt : belt => length(plates) }
}
