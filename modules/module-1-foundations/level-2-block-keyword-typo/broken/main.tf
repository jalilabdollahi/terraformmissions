# Night-sky booking sheet for the Hollow Ridge observatory.
varible "telescope" {
  type    = string
  default = "Dobsonian 12-inch"
}

variable "slot_hours" {
  type    = number
  default = 3
}

resource "local_file" "booking" {
  filename = "${path.module}/sky/booking.txt"
  content  = "Instrument: ${var.telescope}\nSlot length: ${var.slot_hours}h\n"
}

outputs "booking_path" {
  value = local_file.booking.filename
}
