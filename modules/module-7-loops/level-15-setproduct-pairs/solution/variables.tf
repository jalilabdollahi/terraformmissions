variable "rooms" {
  description = "Hackathon rooms."
  type        = list(string)
  default     = ["atrium", "garage", "loft"]
}

variable "days" {
  description = "Hackathon days."
  type        = list(string)
  default     = ["fri", "sat"]
}
