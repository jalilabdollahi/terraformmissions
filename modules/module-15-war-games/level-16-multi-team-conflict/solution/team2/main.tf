data "terraform_remote_state" "team1" {
  backend = "local"
  config = {
    path = "../team1/team1.tfstate"
  }
}

resource "random_string" "app_token" {
  length  = 8
  special = false
  upper   = false
  keepers = {
    upstream = data.terraform_remote_state.team1.outputs.infra_token
  }
}

output "app_token_id" {
  value = random_string.app_token.result
}
