# Crumb & Ember bakery — morning bake planner.
# Maya from the night shift wrote the oven variable the way she says it out loud.
# The plan below multiplies ovens by loaves per oven to size the dough order.

variable "bakery_name" {
  description = "Name printed at the top of the bake plan."
  type        = string
  default     = "Crumb & Ember"
}

variable "oven_count" {
  description = "Deck ovens firing at 4 a.m."
  type        = number
  default     = "three"
}

variable "loaves_per_oven" {
  description = "Loaves one oven turns out per morning."
  type        = number
  default     = 40
}

locals {
  daily_loaves = var.oven_count * var.loaves_per_oven
}

resource "local_file" "bake_plan" {
  filename = "${path.module}/out/bake-plan.txt"
  content  = "${var.bakery_name}: ${var.oven_count} ovens -> ${local.daily_loaves} loaves per morning\n"
}

output "oven_count" {
  value = var.oven_count
}

output "daily_loaves" {
  value = local.daily_loaves
}
