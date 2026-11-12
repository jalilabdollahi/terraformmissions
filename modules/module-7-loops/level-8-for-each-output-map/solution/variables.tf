variable "sessions" {
  description = "Event slug => start time."
  type        = map(string)
  default = {
    "poets-night"    = "19:30"
    "crime-panel"    = "21:15"
    "debut-readings" = "17:00"
  }
}
