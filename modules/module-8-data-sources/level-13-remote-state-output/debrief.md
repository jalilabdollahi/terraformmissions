# Wrong Output Key

## What Was Broken
The reference used `outputs.wrong_output`, but the remote state only contains `outputs.vpc_id`.
Accessing a non-existent key causes a plan-time error.

## The Fix
```hcl
output "network_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}
```

## Accessing Remote State Outputs
```hcl
# Single output
data.terraform_remote_state.vpc.outputs.vpc_id

# All outputs as a map
data.terraform_remote_state.vpc.outputs

# Safe access with fallback
try(data.terraform_remote_state.vpc.outputs.optional_key, "default")
```

## Inspecting a State File
To see available outputs, inspect the state file or the source stack:
```bash
# In the source stack directory
terraform output -json
```