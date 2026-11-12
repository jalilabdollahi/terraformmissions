# Suds & Sparks laundromat — wash-day planner.
# Maya from the night shift wrote the machine variable the way she says it out loud.
# The plan below multiplies machines by cycles per machine to size the detergent order.

variable "laundromat_name" {
  description = "Name printed at the top of the wash plan."
  type        = string
  default     = "Suds & Sparks"
}

variable "machine_count" {
  description = "Front-loading washers running from 6 a.m."
  type        = number
  default     = 3
}

variable "cycles_per_machine" {
  description = "Cycles one machine runs per day."
  type        = number
  default     = 40
}

locals {
  daily_cycles = var.machine_count * var.cycles_per_machine
}

resource "local_file" "wash_plan" {
  filename = "${path.module}/out/wash-plan.txt"
  content  = "${var.laundromat_name}: ${var.machine_count} machines -> ${local.daily_cycles} cycles per day\n"
}

output "machine_count" {
  value = var.machine_count
}

output "daily_cycles" {
  value = local.daily_cycles
}
