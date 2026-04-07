# BUG: terraform_remote_state points to a nonexistent path.
# The validator creates other.tfstate in the working directory.
# Fix the path to point there.

data "terraform_remote_state" "other" {
  backend = "local"
  config = {
    path = "/nonexistent/path/terraform.tfstate"
  }
}

output "remote_output" {
  value = data.terraform_remote_state.other.outputs
}
