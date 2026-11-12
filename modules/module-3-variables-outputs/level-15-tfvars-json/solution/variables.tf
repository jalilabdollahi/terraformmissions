variable "observatory" {
  type = string
}

variable "mirror_diameter_m" {
  description = "Primary mirror diameter in metres."
  type        = number
}

variable "instruments" {
  description = "Instruments mounted on the telescope."
  type        = list(string)
}

variable "site" {
  description = "Geographic position of the dome."
  type = object({
    lat = number
    lon = number
  })
}
