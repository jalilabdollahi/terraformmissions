# Cobbold Wildlife Park — daily feed order for the keepers' whiteboard.
# Species with a tailored ration are listed; anything else gets the standard ration.

variable "rations_kg" {
  type = map(number)
  default = {
    giraffe = 28
    tapir   = 9.5
    lemur   = 1.2
  }
}

variable "standard_ration_kg" {
  type    = number
  default = 3
}

variable "animals" {
  type    = list(string)
  default = ["giraffe", "okapi", "lemur", "capybara"]
}

locals {
  feed_order = {
    for animal in var.animals :
    animal => var.rations_kg[animal]
  }
}

resource "local_file" "whiteboard" {
  filename = "${path.module}/board/feed.txt"
  content = "${join("\n", [for animal, kg in local.feed_order : "${animal}: ${kg} kg"])}\n"
}

output "feed_order" {
  value = local.feed_order
}

output "total_kg" {
  value = sum([for kg in values(local.feed_order) : kg])
}
