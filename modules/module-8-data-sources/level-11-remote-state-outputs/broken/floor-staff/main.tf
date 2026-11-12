# The floor-staff team's configuration. Only its outputs are visible to other teams.

variable "studio_couples" {
  type    = number
  default = 40
}

variable "leads" {
  type    = list(string)
  default = ["Wilhelmina Pike", "Odo Farr"]
}

output "floors" {
  description = "Every floor keyed by name"
  value = {
    grand  = { couples = 120, mirrors = 18 }
    studio = { couples = var.studio_couples, mirrors = 6 }
  }
}

output "staff_leads" {
  description = "Staff leads in order of seniority; the first one is the head caller"
  value       = var.leads
}

output "season" {
  value = "autumn"
}
