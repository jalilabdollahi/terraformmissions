# Show posters for the Hartley Planetarium. One text poster per show.
variable "venue" {
  type    = string
  default = "Hartley Planetarium, Dome A"
}

resource "local_file" "poster" {
  filename = "${path.module}/posters/comet-night.txt"
  content  = "COMET NIGHT\nFriday 20:00 - ${var.venue}\nBring a blanket.\n"
}
