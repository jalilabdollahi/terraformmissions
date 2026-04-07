data "terraform_remote_state" "infra" {
  backend = "local"
  config = {
    path = "../config-a/terraform-a.tfstate"
  }
}

resource "random_string" "app_id" {
  length  = 12
  special = false
  upper   = false
  keepers = {
    infra = data.terraform_remote_state.infra.outputs.infrastructure_id
  }
}

output "app_id" {
  value = random_string.app_id.result
}
