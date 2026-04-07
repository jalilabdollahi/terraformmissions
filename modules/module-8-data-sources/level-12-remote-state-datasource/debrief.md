# Remote State Path Wrong

## What Was Broken
The `config.path` pointed to `./wrong-path/network.tfstate` which does not exist. The
`terraform_remote_state` data source requires the state file to be accessible.

## The Fix
```hcl
data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "./network.tfstate"
  }
}
```

## terraform_remote_state
This data source reads outputs from another Terraform state file, enabling state sharing
between configurations without re-creating resources.

```hcl
# Access outputs from the remote state
output "vpc_id" {
  value = data.terraform_remote_state.network.outputs.vpc_id
}
```

## Backends Supported
- `local` — reads a `.tfstate` file on disk
- `s3` — reads from an S3 bucket
- `gcs`, `azurerm`, `remote`, etc.

## Best Practice
For production, prefer `terraform_remote_state` with a remote backend (S3, GCS) over local
state files for team collaboration.