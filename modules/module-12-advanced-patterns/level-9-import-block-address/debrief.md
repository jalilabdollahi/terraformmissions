# Wrong Import Destination

## What Was Broken
`import { to = module.storage.local_file.config }` references `module.storage`, which is not
declared anywhere in the configuration.

## The Fix
```hcl
import {
  to = local_file.config
  id = "${path.module}/config.txt"
}
```

## import Block (Terraform 1.5+)
The `to` address must resolve to a resource declared in the **current** configuration.
The `id` is the provider-specific import ID for the real resource.

## Why It Matters
The `import` block is the modern, code-review-friendly alternative to `terraform import` CLI.
An incorrect `to` address means the import targets nothing and fails at plan time.