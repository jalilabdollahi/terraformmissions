variable "port_name" {
  description = "Name of the port on the pilotage notice."
  type        = string
}

variable "berth_count" {
  description = "Number of commercial berths."
  type        = number
}

variable "tide_windows" {
  description = "Safe entry windows (HH:MM), in order."
  type        = list(string)
}

variable "pilot_required" {
  description = "Is a harbour pilot compulsory for vessels over 40 m?"
  type        = bool
}
