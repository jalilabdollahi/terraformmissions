# Output from Remote State

## What Was Broken
The `terraform_remote_state` data source had an incorrect path. When the state file doesn't exist
at the specified path, Terraform cannot read the remote outputs and the plan fails.

## The Fix
```hcl
data "terraform_remote_state" "other" {
  backend = "local"
  config = {
    path = "${path.module}/other.tfstate"
  }
}
```

## terraform_remote_state
`data "terraform_remote_state"` reads outputs from another Terraform state file:
```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-tf-state"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_instance" "app" {
  subnet_id = data.terraform_remote_state.vpc.outputs.private_subnet_id
}
```

## Why It Matters
Cross-state references enable modular architectures where different teams manage different
infrastructure components, sharing only the outputs they need.