variable "courts" {
  type    = list(string)
  default = ["freestyle", "dodgeball", "ninja"]
}

resource "random_id" "band" {
  count       = length(var.courts)
  byte_length = 3
}

resource "local_file" "court_card" {
  count    = length(var.courts)
  filename = "${path.module}/cards/${var.courts[count.index]}.txt"
  content  = "court ${var.courts[count.index]} band ${random_id.band[count.index].hex}\n"
}

resource "random_pet" "mascot" {
  length = 2
  prefix = "roo"
}
