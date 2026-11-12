variable "courier_route" {
  type    = string
  default = "harbour-to-hilltop"
}

module "issuer" {
  source = "./modules/issuer"
}

# Leaves the one-shot token in the courier's drop box. The token itself must never be stored.
resource "terraform_data" "handoff" {
  input = {
    route = var.courier_route
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/bin/drop.sh"

    environment = {
      COURIER_ROUTE = self.input.route
      SESSION_TOKEN = module.issuer.session_token
    }
  }
}

output "route" {
  value = terraform_data.handoff.input.route
}
