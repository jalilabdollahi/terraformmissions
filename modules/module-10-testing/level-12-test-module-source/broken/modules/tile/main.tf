variable "edge_cm" {
  description = "Finished edge of one square tile."
  type        = number
  default     = 15
}

variable "tile_count" {
  type    = number
  default = 12
}

output "tile_cm2" {
  # one centimetre of grout on every side
  value = (var.edge_cm + 2) * (var.edge_cm + 2) * var.tile_count
}
