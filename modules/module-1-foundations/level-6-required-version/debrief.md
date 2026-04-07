# Version Lockout

## What Was Broken
`required_version = "= 0.11.0"` pins to an exact old version. Any modern Terraform installation
will be rejected with: `"Terraform v1.x.x does not meet version requirements (= 0.11.0)"`.

## Best Practices for `required_version`
```hcl
required_version = ">= 1.5"          # Allow any Terraform 1.5+
required_version = ">= 1.5, < 2.0"   # Explicit upper bound
required_version = "~> 1.5"          # 1.5.x only
```

## Real-World Use
In teams, `required_version` prevents junior engineers from running old Terraform against
infrastructure managed by a newer version. The state file format changes across major versions,
so this check protects data integrity.