# Mulberry Hill silk farm — silkworm tray planner.
# Each silkworm batch has a hatch time and a tray letter. The type
# constraint was copied from the old "tray only" version of the file.

variable "silkworms" {
  description = "Silkworm name => hatch info."
  type        = map(string)
  default = {
    bombyx = {
      days = 7
      tray = "A"
    }
    tussah = {
      days = 5
      tray = "A"
    }
    muga = {
      days = 12
      tray = "C"
    }
    eri = {
      days = 14
      tray = "B"
    }
  }
}

resource "local_file" "tag" {
  for_each = var.silkworms
  filename = "${path.module}/tags/${each.key}.txt"
  content  = "${each.key}: tray ${each.value.tray}, hatches in ${each.value.days} days\n"
}

output "slowest_days" {
  value = max([for s in var.silkworms : s.days]...)
}

output "trays_in_use" {
  value = sort(distinct([for s in var.silkworms : s.tray]))
}
