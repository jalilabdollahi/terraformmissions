# Variable Default Missing

## What Was Broken
`var.workspace_name` had no `default` value. Running `terraform plan -input=false` (as CI/CD
systems typically do) caused an immediate error because Terraform could not prompt for the value.

## The Fix
```hcl
variable "workspace_name" {
  type    = string
  default = "default"
}
```

## Workspace Commands
```bash
terraform workspace list          # list all workspaces
terraform workspace new staging   # create and switch to "staging"
terraform workspace select default # switch back to default
terraform workspace show          # print current workspace name
terraform workspace delete staging # delete a workspace (must not be active)
```

## Note on Variable vs terraform.workspace
This pattern (storing `terraform.workspace` in a variable) is mostly educational.
In real configs, read `terraform.workspace` directly rather than using an intermediary variable.