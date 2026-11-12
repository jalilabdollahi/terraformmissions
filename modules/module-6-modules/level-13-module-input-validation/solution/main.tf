variable "act" {
  type    = string
  default = "sorcerer"
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

  show_code      = format("%s-%02d", upper(substr(var.act, 0, 3)), var.run_no)
  doors_open_min = var.doors_open_hours * 60
}

output "programme" {
  value = module.billing.programme_line
}
