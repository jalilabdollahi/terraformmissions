variable "legacy_tickets" {
  type = map(string)
  default = {}
}

resource "random_pet" "mechanic" {
  length = 2
  prefix = "mech"
}
