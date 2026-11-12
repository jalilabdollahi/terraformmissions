# Lane booking sheet for the Quayside public swimming baths.
varible "lane" {
  type    = string
  default = "Lane 4 (fast, 25 m)"
}

variable "slot_hours" {
  type    = number
  default = 3
}

resource "local_file" "booking" {
  filename = "${path.module}/lanes/booking.txt"
  content  = "Lane: ${var.lane}\nSlot length: ${var.slot_hours}h\n"
}

outputs "booking_path" {
  value = local_file.booking.filename
}
