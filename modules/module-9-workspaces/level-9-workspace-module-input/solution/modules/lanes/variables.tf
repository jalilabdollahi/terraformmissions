variable "site" {
  type        = string
  description = "Name used in every lane sheet."
}

variable "lane_count" {
  type        = number
  description = "How many lanes to prepare."

  validation {
    condition     = var.lane_count >= 1 && var.lane_count <= 12
    error_message = "A bowling alley needs between 1 and 12 lanes."
  }
}
