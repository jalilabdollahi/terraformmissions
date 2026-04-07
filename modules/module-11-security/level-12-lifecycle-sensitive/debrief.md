# ignore_changes Hiding Security Drift

## What Was Broken
`ignore_changes = [content]` told Terraform to never report or fix changes to the file content.
If an attacker or misconfiguration modified the credentials file, the next `terraform plan`
would show no changes — a false sense of security.

## When ignore_changes Is Appropriate
`ignore_changes` is legitimate when:
- An external process (not Terraform) intentionally manages an attribute.
- The attribute changes frequently and the changes are expected and correct.

It is **never** appropriate for security-critical attributes like credentials, keys, or
certificate content.

## Drift Detection as a Security Control
Regular `terraform plan` or `terraform apply` runs serve as a configuration audit:
- If Terraform shows changes, investigate *why* the live state differs from the desired state.
- Unexpected drift can indicate unauthorized changes or misconfiguration.

## Why It Matters
`ignore_changes` on security attributes creates a blind spot. Combining it with `prevent_destroy`
creates a resource that can be tampered with, and Terraform will never fix or flag it.