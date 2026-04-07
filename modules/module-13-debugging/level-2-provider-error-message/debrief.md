# Wrong Attribute Type

## What Was Broken
`file_permission = 644` passes a number. The `local_file` provider requires a string representing
the Unix file permission in octal notation.

## The Fix
```hcl
file_permission = "0644"
```

## File Permission Strings
- `"0644"` — owner read/write, group read, others read
- `"0600"` — owner read/write only (good for secrets)
- `"0755"` — owner read/write/execute, group and others read/execute

## Why It Matters
Type mismatches are one of the most common Terraform errors. The provider's error message
always tells you the expected type — reading it carefully saves debugging time.