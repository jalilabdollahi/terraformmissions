# Tainted Resource

## What Was Broken
The resource was named `null_resource.job` but the taint command targeted `null_resource.task`.
Terraform cannot taint a resource that doesn't exist in state.

## The Fix
```hcl
resource "null_resource" "task" {
  ...
}
```

## terraform taint (Legacy)
`terraform taint <address>` marks a resource for forced replacement on the next apply:
```bash
terraform taint null_resource.task
terraform plan   # shows: null_resource.task must be replaced
```

**Note:** `terraform taint` is deprecated. The modern approach is:
```bash
terraform apply -replace=null_resource.task
```

The `-replace` flag is preferred because:
- It combines taint + apply into one command
- It doesn't modify state separately
- It's explicit about what will happen

## Why It Matters
Force-replacing resources is necessary when a resource is in a broken state but Terraform
doesn't detect any configuration changes. Common cases: failed provisioners, corrupted resources.