# Sunnyfield sunflower maze — gate timetable.
# The gate board prints the first and the last entry slot of the day.
# Entry slots are listed in order, earliest first.

variable "maze_name" {
  type    = string
  default = "Sunnyfield Sunflower Maze"
}

variable "entry_times" {
  description = "Entry times at the north gate, earliest first."
  type        = list(string)
  default     = ["06:15", "09:40", "13:05", "17:30"]
}

locals {
  first_entry_slot = var.entry_times[0]
  last_entry_slot  = var.entry_times[length(var.entry_times) - 1]
}

resource "local_file" "gate_board" {
  filename = "${path.module}/board/gate.txt"
  content  = <<-EOT
    ${var.maze_name}
    First entry:   ${local.first_entry_slot}
    Last entry:    ${local.last_entry_slot}
  EOT
}

output "last_entry" {
  value = local.last_entry_slot
}

output "entries_per_day" {
  value = length(var.entry_times)
}
