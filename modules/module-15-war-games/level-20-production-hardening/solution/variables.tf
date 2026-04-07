variable "token_length" {
  type        = number
  description = "Length of the generated token"
  default     = 16

  validation {
    condition     = var.token_length >= 8
    error_message = "token_length must be at least 8 characters for security compliance."
  }
}
