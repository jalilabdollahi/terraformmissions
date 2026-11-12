variable "stalls" {
  type = set(string)
}

module "stalls" {
  source = "./stalls"
  names  = var.stalls
}

resource "terraform_data" "oil_cycle" {
  triggers_replace = {
    cycle = "weekly"
  }
}

output "loads" {
  value = module.stalls.loads
}

output "oil_id" {
  value = terraform_data.oil_cycle.id
}
