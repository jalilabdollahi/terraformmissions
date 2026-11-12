variable "screenings" {
  description = "Film slug => start time."
  type        = map(string)
  default = {
    "night-ferry"   = "19:30"
    "salt-and-iron" = "21:15"
    "paper-lanterns" = "17:00"
  }
}
