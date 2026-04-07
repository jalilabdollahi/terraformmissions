# Already in State

## What Was Broken
`import { to = local_file.wrong_resource }` references a resource that is not declared.
The `to` address must correspond to an existing resource declaration in the configuration.

## The Fix
```hcl
import {
  to = local_file.config
  id = "${path.module}/config.txt"
}
```

## import Block Address Rules
- `to` must reference a resource declared in the current root module or a child module
- The address format is `resource_type.resource_label` or `module.label.resource_type.resource_label`
- The resource must NOT already be in state (that would be a conflict)

## Why It Matters
Getting the `to` address wrong either results in a validation error (undeclared resource)
or attempts to import into an already-managed resource (conflict error).