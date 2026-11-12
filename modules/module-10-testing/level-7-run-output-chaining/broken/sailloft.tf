variable "luff_m" {
  description = "Length of the sail's leading edge."
  type        = number
  default     = 8
}

variable "foot_m" {
  description = "Length of the sail's bottom edge."
  type        = number
  default     = 3
}

variable "order_area_m2" {
  description = "Area to order cloth for. Defaults to this sail's own area."
  type        = number
  default     = null
}

locals {
  sail_area = 0.5 * var.luff_m * var.foot_m
}

output "sail_area" {
  value = local.sail_area
}

output "cloth_ordered_m2" {
  value = ceil(coalesce(var.order_area_m2, local.sail_area) * 1.1)
}
