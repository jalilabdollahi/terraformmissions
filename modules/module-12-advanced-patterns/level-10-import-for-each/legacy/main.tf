variable "legacy_tickets" {
  type = map(string)
  default = {}
}

resource "random_pet" "shaper" {
  length = 2
  prefix = "shaper"
}
