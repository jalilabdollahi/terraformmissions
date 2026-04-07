data "terraform_remote_state" "team1" {
  backend = "local"
  config = {
    path = "../team1/team1.tfstate"
  }
}

# BUG: team1 exports "infra_token" but team2 references "network_token" (wrong key).
resource "random_string" "app_token" {
  length  = 8
  special = false
  upper   = false
  keepers = {
    upstream = data.terraform_remote_state.team1.outputs.network_token
  }
}

output "app_token_id" {
  value = random_string.app_token.result
}
