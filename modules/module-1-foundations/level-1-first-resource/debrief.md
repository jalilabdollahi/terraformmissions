# Your First Resource

## What Was Broken
The `resource` block was missing its closing brace `}`. HCL (HashiCorp Configuration Language) uses
matching `{` and `}` to delimit blocks. Without the closing brace, the parser cannot determine where
the block ends.

## The Fix
Add `}` at the end of the resource block to close it properly.

## Why It Matters
HCL syntax errors are the first class of problems you'll encounter. The `terraform validate` command
catches them without needing a provider connection. Always run `terraform validate` before `terraform plan`.

## Commands You Used
```bash
terraform validate   # static syntax + type check
```