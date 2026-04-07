# The remote state has output "vpc_id" but we reference "wrong_output".
# Fix: change outputs.wrong_output to outputs.vpc_id

data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "./vpc.tfstate"
  }
}

output "network_id" {
  value = data.terraform_remote_state.vpc.outputs.wrong_output
}
