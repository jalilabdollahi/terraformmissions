variable "pace_sec_per_km" {
  description = "Planned pace in seconds per kilometre."
  type        = number
  default     = 330
}

variable "cutoff_minutes" {
  description = "Course closes after this many minutes."
  type        = number
  default     = 90
}

locals {
  distance_km    = 12.4
  checkpoints_km = [3, 6, 9, 11]
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
