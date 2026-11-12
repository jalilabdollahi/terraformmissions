variable "code_length" {
  type    = number
  default = 6
}

module "room" {
  source = "./modules/room"

  digits = var.code_length
}

resource "local_sensitive_file" "booking" {
  filename = "${path.module}/keys/booking.txt"
  content  = "DOOR ${module.room.code}\n"
}

output "door_code" {
  value = module.room.code
}
