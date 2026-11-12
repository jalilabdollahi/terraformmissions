variable "dose_mg" {
  description = "Single dose in milligrams."
  type        = number
  default     = 250

  validation {
    condition     = var.dose_mg > 0 && var.dose_mg <= 500
    error_message = "A single dose must be between 1 and 500 mg."
  }
}

variable "interval_hours" {
  description = "Hours between doses."
  type        = number
  default     = 8

  validation {
    condition     = var.interval_hours >= 4
    error_message = "Doses must be at least 4 hours apart."
  }
}

output "label" {
  value = "${var.dose_mg} mg every ${var.interval_hours} h"
}

output "daily_total_mg" {
  value = var.dose_mg * floor(24 / var.interval_hours)
}
