variable "name" {
  type = string
}

variable "depth" {
  type = number
}

resource "random_id" "tag" {
  byte_length = 3
  prefix      = "${var.name}-"
}

resource "local_file" "placard" {
  filename = "${path.root}/placards/${var.name}.txt"
  content  = "${var.name} shaft, ${var.depth} m, inspection tag ${random_id.tag.hex}\n"
}

output "tag" {
  value = random_id.tag.hex
}
