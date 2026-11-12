variable "con_name" {
  type    = "string"
  default = "Nova City Comic Con"
}

variable "stalls" {
  type    = "list"
  default = ["posters", "cards", "figures"]
}

variable "prices" {
  type = "map"
  default = {
    posters = 4
    cards   = 3
    figures = 6
  }
}
