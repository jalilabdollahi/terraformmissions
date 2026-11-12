variable "yard_name" {
  type    = string
  default = "Calder Reach Shipyard"
}

variable "annex_enabled" {
  description = "The north annex berths are being decommissioned; flip to false to retire them."
  type        = bool
  default     = true
}
