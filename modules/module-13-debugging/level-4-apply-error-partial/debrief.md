# Partial Apply Recovery

## What Was Broken
`file_permission = "999"` is not a valid octal permission string. `9` is not an octal digit
(octal uses 0-7). The provider rejects this value during apply.

## The Fix
```hcl
file_permission = "0644"
```

## Partial Apply Situations
When an apply partially succeeds:
1. Resources that completed are now in state
2. Failed resources are not in state
3. Re-run `terraform apply` — already-created resources are no-ops

## Valid file_permission Values
- Must be a 4-character octal string: `"0644"`, `"0600"`, `"0755"`, `"0400"`
- Only digits 0-7 are valid in each position

## Why It Matters
Partial apply recovery is a key operational skill. Understanding which resources succeeded
and which failed helps you plan the remediation correctly.