data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "./vpc.tfstate"
  }
}

output "network_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}
