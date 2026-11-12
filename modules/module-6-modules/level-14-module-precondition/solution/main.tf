variable "flight_class" {
  type    = string
  default = "standard"
}

variable "passengers" {
  type    = number
  default = 10
}

module "booking" {
  source = "./modules/booking"

  flight_class = var.flight_class
  passengers   = var.passengers
}

resource "local_file" "manifest" {
  filename = "${path.module}/manifest.txt"
  content  = "${module.booking.summary}\n"
}

output "summary" {
  value = module.booking.summary
}
