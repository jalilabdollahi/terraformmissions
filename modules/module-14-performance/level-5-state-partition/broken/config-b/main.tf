data "terraform_remote_state" "infra" {
  backend = "local"
  config = {
    path = "../config-a/terraform-a.tfstate"
  }
}

# BUG: The output key is wrong. Config-a exports "infrastructure_id", not "infra_id".
resource "random_string" "app_id" {
  length  = 12
  special = false
  upper   = false
  keepers = {
    infra = data.terraform_remote_state.infra.outputs.infra_id
  }
}

output "app_id" {
  value = random_string.app_id.result
}
