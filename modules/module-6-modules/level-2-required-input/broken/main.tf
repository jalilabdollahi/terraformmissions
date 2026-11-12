variable "vessel_beam_m" {
  type    = number
  default = 4
}

variable "vessel_length_m" {
  type    = number
  default = 18
}

module "lockgate" {
  source = "./modules/lockgate"

  canal    = "Willowbrook Cut"
  length_m = var.vessel_length_m
}

resource "local_file" "ledger" {
  filename = "${path.module}/ledger/willowbrook.txt"
  content  = "toll_pence=${module.lockgate.toll_pence}\n"
}

output "toll_pence" {
  value = module.lockgate.toll_pence
}
