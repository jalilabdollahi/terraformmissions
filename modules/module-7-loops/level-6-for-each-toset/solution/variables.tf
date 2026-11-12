variable "dealers" {
  description = "Dealers trading this week. The same dealer may be listed by two stalls."
  type        = list(string)
  default     = ["ashby", "briggs", "calloway", "briggs", "dunmore"]
}
