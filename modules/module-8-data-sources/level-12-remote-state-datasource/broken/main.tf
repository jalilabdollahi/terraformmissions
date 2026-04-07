# The remote state config.path is wrong — it points to a non-existent path.
# Fix: change the path to "./network.tfstate"

data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "./wrong-path/network.tfstate"
  }
}

output "vpc_id" {
  value = data.terraform_remote_state.network.outputs.vpc_id
}
