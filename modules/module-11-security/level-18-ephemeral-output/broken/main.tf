variable "taxi_route" {
  type    = string
  default = "station-to-airport"
}

module "issuer" {
  source = "./modules/issuer"
}

# Leaves the one-shot token in the dispatch box. The token itself must never be stored.
resource "terraform_data" "handoff" {
  input = {
    route = var.taxi_route
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/bin/handoff.sh"

    environment = {
      TAXI_ROUTE = self.input.route
      SESSION_TOKEN = module.issuer.session_token
    }
  }
}

output "route" {
  value = terraform_data.handoff.input.route
}
