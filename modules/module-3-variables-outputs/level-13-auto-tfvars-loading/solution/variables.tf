variable "spa_room" {
  type    = string
  default = "Birch Room 3"
}

variable "target_temp_c" {
  description = "Target air temperature in degrees C."
  type        = number
  default     = 70
}

variable "vent_mode" {
  description = "manual | auto"
  type        = string
  default     = "manual"
}

variable "steam_per_day" {
  description = "How many steam bursts per day."
  type        = number
  default     = 2
}
