variable "slots" {
  description = "Pickup slot name => who comes, how many boxes, and when."
  type = map(object({
    volunteer = string
    boxes     = number
    time      = string
  }))
  default = {
    early  = { volunteer = "Ines", boxes = 12, time = "08:30" }
    noon   = { volunteer = "Tomasz", boxes = 8, time = "12:00" }
    sunset = { volunteer = "Ravi", boxes = 20, time = "18:45" }
  }
}
