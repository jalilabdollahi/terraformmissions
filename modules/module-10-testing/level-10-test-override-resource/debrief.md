# Wrong Resource Address in override_resource

## What Was Broken
The `override_resource` block targeted `local_file.wrong_name`, but the actual resource in the
configuration is `local_file.config`. Terraform could not find the target and rejected the override.

## override_resource Syntax
```hcl
override_resource {
  target = resource_type.resource_name  # must match exactly
  values = {
    computed_attr = "override_value"
  }
}
```

## What override_resource Does
`override_resource` replaces the provider's handling of a specific resource during a test. Instead
of calling the real provider CRUD, Terraform uses the `values` you specify. This is useful when:
- You want to test downstream logic without creating real infrastructure.
- The resource creation is slow or requires credentials you don't have in CI.

## Why It Matters
Precise resource addressing is fundamental. A typo in the target silently fails to override the
intended resource. Always cross-reference the target address with the actual resource declarations.