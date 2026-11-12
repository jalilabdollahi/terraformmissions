variable "fair_name" {
  type    = string
  default = "Ashby County Fair"
}

variable "stalls" {
  type    = list(string)
  default = ["pies", "jam", "honey"]
}

variable "prices" {
  type = map(number)
  default = {
    pies  = 4
    jam   = 3
    honey = 6
  }
}
