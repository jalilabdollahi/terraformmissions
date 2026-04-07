# State Inspector

## What Was Broken
The output block referenced `random_string.delta.result`, but no resource named `delta` was declared
in the configuration. Terraform cannot resolve references to undeclared resources.

## The Fix
```hcl
output "last_string" {
  value = random_string.gamma.result
}
```

## State Inspection Commands
```bash
terraform state list          # list all resources tracked in state
terraform state show <addr>   # show attributes of a specific resource
terraform output <name>       # print an output value
```

## Why It Matters
Understanding how to read state is fundamental. `terraform state list` gives you a quick
inventory of everything Terraform is managing, and `terraform state show` lets you inspect
each resource's current attribute values without applying any changes.