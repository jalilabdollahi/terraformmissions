# File Not Found

## What Was Broken
The `data "local_file"` block referenced `missing.txt` which does not exist, while the actual
file `data.txt` was present in the same directory.

## The Fix
```hcl
data "local_file" "config" {
  filename = "${path.module}/data.txt"
}
```

## Key Concepts
- `data` blocks declare **data sources** — they read existing infrastructure or files rather than creating them.
- `path.module` is a built-in reference to the directory of the current module's configuration files.
- Data sources are read during `terraform plan`, so a missing file causes the plan to fail.

## Commands You Used
```bash
terraform plan   # reads data sources and builds execution plan
```