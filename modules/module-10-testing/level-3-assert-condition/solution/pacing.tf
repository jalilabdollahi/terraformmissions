variable "pace_sec_per_km" {
  description = "Planned pace in seconds per kilometre."
  type        = number
  default     = 330
}

variable "cutoff_minutes" {
  description = "Course closes after this many minutes."
  type        = number
  default     = 360
}

locals {
  distance_km    = 42.195
  checkpoints_km = [10, 20, 30, 40]
}

output "finish_minutes" {
  value = floor(local.distance_km * var.pace_sec_per_km / 60)
}

output "checkpoint_minutes" {
  value = [for km in local.checkpoints_km : floor(km * var.pace_sec_per_km / 60)]
}

output "within_cutoff" {
  value = floor(local.distance_km * var.pace_sec_per_km / 60) < var.cutoff_minutes
}
