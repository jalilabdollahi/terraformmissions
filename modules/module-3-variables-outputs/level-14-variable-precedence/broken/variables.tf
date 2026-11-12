variable "pad_name" {
  description = "Launch pad designation."
  type        = string
}

variable "countdown_minutes" {
  description = "Length of the pre-launch countdown in minutes."
  type        = number
  default     = 60
}

variable "hold_points" {
  description = "Planned hold points (T-minus minutes)."
  type        = list(number)
  default     = [30, 10]
}
