variable "arena" {
  type = string
}

variable "dome_diameter_m" {
  description = "Diameter of the scoreboard dome in metres."
  type        = number
}

variable "game_modes" {
  description = "Game modes offered in the arena."
  type        = list(string)
}

variable "site" {
  description = "Geographic position of the arena."
  type = object({
    lat = number
    lon = number
  })
}
