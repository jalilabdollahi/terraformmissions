# MISSING: variable validation block to enforce minimum length >= 8
variable "token_length" {
  type        = number
  description = "Length of the generated token"
  default     = 16
}
