# Module Migration Mismatch

## What Was Broken
`moved { to = module.wrong_module.local_file.config }` references `module.wrong_module`, but the
only declared module is `module "storage"`. Terraform cannot resolve the destination address.

## The Fix
```hcl
moved {
  from = local_file.config
  to   = module.storage.local_file.config
}
```

## Module Address Format
When moving a resource into a module, the `to` address follows the pattern:
```
module.<module_label>.<resource_type>.<resource_label>
```

## Why It Matters
Moving resources into modules is a common refactoring step when growing a Terraform codebase.
Getting the module address wrong causes Terraform to plan a destroy+create cycle instead of a
safe in-place move.