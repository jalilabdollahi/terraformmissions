data "terraform_remote_state" "team_a" {
  backend = "local"
  config = {
    path = "../team-a/team-a.tfstate"
  }
}

# BUG 1: Team A exports "cluster_identifier" but Team B references "cluster_id" (wrong key).
# BUG 2: Team A exports "network_id" but Team B references "vpc_id" (wrong key).
resource "random_string" "app_instance" {
  length  = 6
  special = false
  upper   = false
  keepers = {
    cluster = data.terraform_remote_state.team_a.outputs.cluster_id
    network = data.terraform_remote_state.team_a.outputs.vpc_id
  }
}

output "app_instance_id" {
  value = random_string.app_instance.result
}
