variable "pins" {
  description = "Operator name => gate PIN."
  type        = map(string)
  sensitive   = true
}
