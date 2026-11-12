variable "snack_bar_open" {
  description = "Is the snack bar open tonight?"
  type        = bool
  default     = true
}

variable "snack_items" {
  description = "What the snack bar sells."
  type        = list(string)
  default     = ["popcorn", "nachos"]
}
