variable "hour" {
  type        = number
  description = "Current hour of the day, 0-23"
  default     = 14
}

module "crier" {
  source = "./modules/crier"

  name = "Master Aldous"
  hour = var.hour
}

output "next_call" {
  value = module.crier.next_call
}

output "roster_file" {
  value = module.crier.roster_file
}
