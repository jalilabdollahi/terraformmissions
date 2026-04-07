variable "environment" {
  type        = string
  description = "Deployment environment (dev, staging, production)"
  default     = "development"
}

variable "debug" {
  type        = bool
  description = "Enable debug mode"
  default     = false
}
