variable "show_code" {
  type        = string
  description = "Production code such as SOR-07: three capital letters, a dash, two digits"

  validation {
    condition     = can(regex("^[A-Z]{3}-[0-9]{2}$", var.show_code))
    error_message = "show_code must be three capital letters, a dash and two digits, e.g. SOR-07."
  }
}

variable "doors_open_min" {
  type        = number
  description = "Minutes between doors opening and curtain"

  validation {
    condition     = var.doors_open_min >= 15 && var.doors_open_min <= 90
    error_message = "doors_open_min must be between 15 and 90 minutes."
  }
}

output "programme_line" {
  value = "${var.show_code} | doors ${var.doors_open_min} min before curtain"
}
