# Postcondition File Permission Mismatch

## What Was Broken
The postcondition asserted `self.file_permission == "0644"`, but the resource set
`file_permission = "0600"`. Since `0600 != 0644`, the postcondition always failed.

## Postcondition as a Security Audit Gate
Postconditions are evaluated *after* apply and check the actual resulting state. They are
powerful for security auditing:

```hcl
lifecycle {
  postcondition {
    condition     = self.file_permission == "0600"
    error_message = "Credential file must not be world-readable. Got: ${self.file_permission}."
  }
}
```

If someone changes the `file_permission` to `"0644"`, the apply will fail with the postcondition
error — immediately catching the security regression.

## self Reference in Postconditions
Inside a `postcondition`, `self` refers to the resource's post-apply attributes, allowing you
to verify the actual deployed state rather than the planned state.

## Why It Matters
Postconditions act as automated security compliance checks. A mismatch between the intended
permission (`"0644"`) and the secure default (`"0600"`) would typically be a bug in the
postcondition, not in the resource.