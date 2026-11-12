variable "greenhouse" {
  type    = string
  default = "Glasshouse 3"
}

variable "target_temp_c" {
  description = "Target air temperature in degrees C."
  type        = number
  default     = 18
}

variable "vent_mode" {
  description = "manual | auto"
  type        = string
  default     = "manual"
}

variable "misting_per_day" {
  description = "How many misting cycles per day."
  type        = number
  default     = 2
}
