variable "panel_width_cm" {
  type    = number
  default = 150
}

variable "panel_length_cm" {
  type    = number
  default = 200
}

variable "strip_cm" {
  description = "Width of the frieze strip."
  type        = number
  default     = 10
}

output "frieze_cm2" {
  value = 2 * (var.panel_width_cm + var.panel_length_cm) * var.strip_cm + 4 * var.strip_cm * var.strip_cm
}
