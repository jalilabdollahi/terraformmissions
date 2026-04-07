data "terraform_remote_state" "other" {
  backend = "local"
  config = {
    path = "${path.module}/other.tfstate"
  }
}

output "remote_output" {
  value = data.terraform_remote_state.other.outputs
}
