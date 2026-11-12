variable "troupe" {
  type    = string
  default = "marionette"
}

variable "run_no" {
  type    = number
  default = 7
}

variable "doors_open_hours" {
  type    = number
  default = 1
}

module "billing" {
  source = "./modules/billing"

  show_code      = "${var.troupe}-${var.run_no}"
  doors_open_min = var.doors_open_hours
}

output "programme" {
  value = module.billing.programme_line
}
