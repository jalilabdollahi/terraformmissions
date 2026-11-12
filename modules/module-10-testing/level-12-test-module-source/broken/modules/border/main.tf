variable "quilt_width_cm" {
  type    = number
  default = 150
}

variable "quilt_length_cm" {
  type    = number
  default = 200
}

variable "strip_cm" {
  description = "Width of the border strip."
  type        = number
  default     = 10
}

output "border_cm2" {
  value = 2 * (var.quilt_width_cm + var.quilt_length_cm) * var.strip_cm + 4 * var.strip_cm * var.strip_cm
}
