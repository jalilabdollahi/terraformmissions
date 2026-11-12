variable "pins" {
  description = "Operator name => cab PIN."
  type        = map(string)
  sensitive   = true
}
