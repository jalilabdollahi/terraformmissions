variable "vehicle_tonnes" {
  description = "Gross weight of the vehicle."
  type        = number
  default     = 28
}

variable "vehicle_height_m" {
  description = "Height of the vehicle."
  type        = number
  default     = 3.0
}

resource "terraform_data" "crossing_permit" {
  input = "permit:${var.vehicle_tonnes}t/${var.vehicle_height_m}m"

  lifecycle {
    precondition {
      condition     = var.vehicle_tonnes <= 40
      error_message = "Vehicles over 40 tonnes may not cross."
    }

    precondition {
      condition     = var.vehicle_height_m <= 4.5
      error_message = "Vehicles taller than 4.5 m do not fit under the arch."
    }
  }
}

output "permit_code" {
  value = terraform_data.crossing_permit.input
}
