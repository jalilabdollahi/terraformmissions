variable "shell_kg" {
  description = "Net explosive weight of the display in kilograms."
  type        = number
  default     = 28
}

variable "rack_height_m" {
  description = "Height of the firing rack stack."
  type        = number
  default     = 3.0
}

resource "terraform_data" "display_permit" {
  input = "permit:${var.shell_kg}kg/${var.rack_height_m}m"

  lifecycle {
    precondition {
      condition     = var.shell_kg <= 40
      error_message = "Displays over 40 kg of explosive may not be licensed."
    }

    precondition {
      condition     = var.rack_height_m <= 4.5
      error_message = "Firing racks taller than 4.5 m are unstable in wind."
    }
  }
}

output "permit_code" {
  value = terraform_data.display_permit.input
}
