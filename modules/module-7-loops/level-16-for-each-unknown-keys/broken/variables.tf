variable "samples" {
  description = "Sample names collected on the dive."
  type        = list(string)
  default     = ["kelp-a", "kelp-b", "urchin-c"]
}
