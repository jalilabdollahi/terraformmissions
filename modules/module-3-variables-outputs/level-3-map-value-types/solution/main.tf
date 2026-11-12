# Fernwood Nursery — seedling tray planner.
# Each seedling has a germination time and a tray letter. The type
# constraint was copied from the old "tray only" version of the file.

variable "seedlings" {
  description = "Seedling name => germination info."
  type = map(object({
    days = number
    tray = string
  }))
  default = {
    tomato = {
      days = 7
      tray = "A"
    }
    basil = {
      days = 5
      tray = "A"
    }
    pepper = {
      days = 12
      tray = "C"
    }
    leek = {
      days = 14
      tray = "B"
    }
  }
}

resource "local_file" "label" {
  for_each = var.seedlings
  filename = "${path.module}/labels/${each.key}.txt"
  content  = "${each.key}: tray ${each.value.tray}, sprouts in ${each.value.days} days\n"
}

output "slowest_days" {
  value = max([for s in var.seedlings : s.days]...)
}

output "trays_in_use" {
  value = sort(distinct([for s in var.seedlings : s.tray]))
}
