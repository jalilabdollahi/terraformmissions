variable "spices" {
  description = "Spices on sale this week. The same spice may be listed by two stalls."
  type        = list(string)
  default     = ["cardamom", "saffron", "sumac", "saffron", "za-atar"]
}
