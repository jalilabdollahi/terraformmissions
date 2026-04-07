data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "./network.tfstate"
  }
}

output "vpc_id" {
  value = data.terraform_remote_state.network.outputs.vpc_id
}
