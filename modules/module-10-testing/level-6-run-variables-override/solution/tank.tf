variable "tank_liters" {
  description = "Water volume of the display tank."
  type        = number
  default     = 120
}

variable "stock" {
  description = "Fish per species in the tank."
  type        = map(number)
  default = {
    neon_tetra = 10
    corydoras  = 4
  }
}

locals {
  fish_total = sum(values(var.stock))
  per_fish   = var.tank_liters / local.fish_total
}

output "fish_total" {
  value = local.fish_total
}

output "liters_per_fish" {
  value = local.per_fish
}

output "overstocked" {
  value = local.per_fish < 5
}
