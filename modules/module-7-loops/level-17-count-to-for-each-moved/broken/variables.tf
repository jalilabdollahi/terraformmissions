variable "stations" {
  description = "Lifeboat stations in the order they were originally listed."
  type        = list(string)
  default     = ["padstow", "sennen", "penlee"]
}
