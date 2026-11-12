variable "kind" {
  type = string
}

locals {
  anneal_hours = {
    bowl        = 6
    vase        = 10
    ornament    = 4
    paperweight = 14
  }
}

resource "terraform_data" "anneal" {
  input = {
    kind  = var.kind
    hours = local.anneal_hours[var.kind]
  }
}

output "hours" {
  value = terraform_data.anneal.input.hours
}
