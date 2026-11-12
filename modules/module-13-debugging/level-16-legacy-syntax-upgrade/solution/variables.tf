variable "con_name" {
  type    = string
  default = "Nova City Comic Con"
}

variable "stalls" {
  type    = list(string)
  default = ["posters", "cards", "figures"]
}

variable "prices" {
  type = map(number)
  default = {
    posters = 4
    cards   = 3
    figures = 6
  }
}
