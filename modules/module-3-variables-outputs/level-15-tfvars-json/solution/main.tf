# Neon Rift laser tag arena — arena configuration sheet.
# Inputs are exported from the booking system as terraform.tfvars.json.

locals {
  dot_ratio = pow(var.dome_diameter_m / 0.007, 2)
}

resource "local_file" "arena_sheet" {
  filename = "${path.module}/arena/sheet.txt"
  content  = <<-EOT
    ${var.arena} (${var.site.lat}, ${var.site.lon})
    Dome: ${var.dome_diameter_m} m
    Modes: ${join(", ", var.game_modes)}
  EOT
}

output "arena" {
  value = var.arena
}

output "mode_count" {
  value = length(var.game_modes)
}

output "arena_latitude" {
  value = var.site.lat
}

output "dome_vs_laser_dot" {
  value = floor(local.dot_ratio)
}
