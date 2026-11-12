variable "hour" {
  type        = number
  description = "Current hour of the day, 0-23"
  default     = 14
}

module "tower" {
  source = "./modules/tower"

  name = "Saint Aldric"
  hour = var.hour
}

output "next_chime" {
  value = module.tower.next_chime
}

output "roster_file" {
  value = module.tower.roster_file
}
