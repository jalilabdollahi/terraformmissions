variable "boat" {
  type = string
}

resource "random_pet" "cabin" {
  length    = 2
  separator = "-"
  prefix    = "${var.boat}-cabin"
}

output "cabin_label" {
  value = random_pet.cabin.id
}
