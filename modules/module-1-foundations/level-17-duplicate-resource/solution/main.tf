# Flash sheets for the Inkwell Row tattoo studio. One text flash sheet per design.
variable "venue" {
  type    = string
  default = "Inkwell Row Tattoo, Booth A"
}

resource "local_file" "flash_sheet" {
  filename = "${path.module}/flash/swallow.txt"
  content  = "SWALLOW\nFriday 18:00 - ${var.venue}\nWalk-ins welcome.\n"
}
