# Negative Count Crash

## What Was Broken
`count = -1` is an invalid value. Terraform's `count` meta-argument must be a non-negative
integer (0 or greater).

## The Fix
```hcl
count = 1
```

## count Value Rules
| Value | Result |
|---|---|
| `0` | No instances created (resource is "disabled") |
| `1` | One instance |
| `N` | N instances (indexes 0 to N-1) |
| `-1` | Invalid — error |
| Unknown | Invalid at plan time — error |

## Reading Terraform Error Patterns
Terraform's error messages for invalid values always include:
1. The attribute that has the invalid value
2. The constraint that was violated
3. Sometimes a suggestion for the correct value

## Why It Matters
Negative counts and similar invalid values are typically introduced by:
- Bug in a calculation: `var.scale - var.reserved` going negative
- Wrong variable default
- Copy-paste error

Always validate calculated `count` values are non-negative before using them.