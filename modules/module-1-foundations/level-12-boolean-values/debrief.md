# True or False?

## What Was Broken
`special = "true"` is a string. Terraform expects a boolean `true` for that attribute.

## Booleans in HCL
```hcl
special = true     # ✅ boolean true
special = false    # ✅ boolean false
special = "true"   # ❌ this is a string
special = "false"  # ❌ this is a string
```

## When Does This Matter?
Many Terraform providers perform strict type checking. Even though Terraform has some automatic
type coercion, you should always use the correct type to avoid surprises.