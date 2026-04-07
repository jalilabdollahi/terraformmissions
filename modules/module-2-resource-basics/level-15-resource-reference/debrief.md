# Missing the Attribute Dot

## What Was Broken
`${random_string.token}` references the resource object as a whole. In a string interpolation
context, Terraform expects a string, number, or bool — not an object. The correct reference is
`${random_string.token.result}`.

## The Fix
```hcl
content = "Token: ${random_string.token.result}"
```

## Resource Reference Anatomy
```
random_string . token . result
─────────────   ─────   ──────
resource type   name    attribute
```

Every resource reference follows the pattern: `<type>.<name>.<attribute>`

## Why It Matters
Forgetting the attribute name is a very common mistake when writing resource references. Terraform's
type system detects the mismatch between an object and an expected string at validate time, before
any infrastructure is touched.