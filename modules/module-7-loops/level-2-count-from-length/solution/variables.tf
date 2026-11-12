variable "dogs" {
  description = "Every dog currently on the kennel roster."
  type        = list(string)
  default     = ["Tundra", "Juneau", "Kodiak", "Sitka", "Nome"]
}

variable "ration_kg" {
  description = "Daily ration per dog, in kilograms."
  type        = number
  default     = 1.5
}
