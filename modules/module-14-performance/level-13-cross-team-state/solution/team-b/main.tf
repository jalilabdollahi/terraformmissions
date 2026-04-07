data "terraform_remote_state" "team_a" {
  backend = "local"
  config = {
    path = "../team-a/team-a.tfstate"
  }
}

resource "random_string" "app_instance" {
  length  = 6
  special = false
  upper   = false
  keepers = {
    cluster = data.terraform_remote_state.team_a.outputs.cluster_identifier
    network = data.terraform_remote_state.team_a.outputs.network_id
  }
}

output "app_instance_id" {
  value = random_string.app_instance.result
}
