variable "rooms" {
  type = set(string)
}

module "rooms" {
  source = "./rooms"
  names  = var.rooms
}

resource "terraform_data" "cip_cycle" {
  triggers_replace = {
    cycle = "weekly"
  }
}

output "shelves" {
  value = module.rooms.shelves
}

output "cip_id" {
  value = terraform_data.cip_cycle.id
}
