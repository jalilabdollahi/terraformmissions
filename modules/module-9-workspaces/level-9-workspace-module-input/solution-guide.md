# Solution guide

**Diagnose.** In `pr-142`:

```
terraform plan
Error: Invalid value for variable ... A bowling alley needs between 1 and 12 lanes.
```

The module is correct. The root passes `lane_count = 0` because
`terraform.workspace == "prod" ? 4 : terraform.workspace == "staging" ? 2 : 0` ends in `0`.

**Fix.** Give the fallback a sensible value, ideally through a map with a default:

```hcl
locals {
  lanes = { prod = 4, staging = 2 }
}
...
lane_count = lookup(local.lanes, terraform.workspace, 1)
```

Do not touch the module's validation: it is doing its job.
