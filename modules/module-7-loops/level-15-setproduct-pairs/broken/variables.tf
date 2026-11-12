variable "rooms" {
  description = "Rehearsal rooms."
  type        = list(string)
  default     = ["aria", "cantata", "motet"]
}

variable "days" {
  description = "Rehearsal days."
  type        = list(string)
  default     = ["fri", "sat"]
}
