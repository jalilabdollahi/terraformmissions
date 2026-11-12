# The stage-crew team's configuration. Only its outputs are visible to other teams.

variable "studio_seats" {
  type    = number
  default = 40
}

variable "leads" {
  type    = list(string)
  default = ["Wilhelmina Pike", "Odo Farr"]
}

output "stages" {
  description = "Every stage keyed by name"
  value = {
    main   = { seats = 120, fly_bars = 18 }
    studio = { seats = var.studio_seats, fly_bars = 6 }
  }
}

output "crew_leads" {
  description = "Crew leads in order of seniority; the first one is the head rigger"
  value       = var.leads
}

output "season" {
  value = "autumn"
}
