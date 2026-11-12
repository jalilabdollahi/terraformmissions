variable "cabinets" {
  type    = list(string)
  default = ["skee-ball", "claw", "racer"]
}

resource "random_id" "token" {
  count       = length(var.cabinets)
  byte_length = 3
}

resource "local_file" "cabinet_card" {
  count    = length(var.cabinets)
  filename = "${path.module}/cards/${var.cabinets[count.index]}.txt"
  content  = "cabinet ${var.cabinets[count.index]} token ${random_id.token[count.index].hex}\n"
}

resource "random_pet" "mascot" {
  length = 2
  prefix = "gull"
}
