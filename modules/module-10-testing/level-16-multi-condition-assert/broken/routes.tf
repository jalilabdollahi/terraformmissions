variable "grade" {
  description = "French sport grade of the route."
  type        = string
  default     = "6a"
}

variable "height_m" {
  description = "Height of the route in metres."
  type        = number
  default     = 17
}

locals {
  colours = {
    "5c" = "yellow"
    "6a" = "green"
    "6b" = "blue"
    "7a" = "red"
  }
}

output "route" {
  value = {
    grade       = var.grade
    colour      = local.colours[var.grade]
    bolts       = floor(var.height_m / 2)
    top_rope_ok = var.height_m <= 20
  }
}
