# Null and Non-Nullable Don't Mix

## What Was Broken
`nullable = false` declares that the variable will never have a null value. Setting
`default = null` contradicts this guarantee — if the default is null, the variable starts as null.

## The Fix
```hcl
variable "environment" {
  type     = string
  nullable = false
  default  = "production"
}
```

## The `nullable` Attribute

| Setting           | Meaning |
|------------------|---------|
| `nullable = true` (default) | Variable can be `null`; callers can pass `null` to unset it |
| `nullable = false` | Variable is always non-null; Terraform uses the default when `null` is passed |

## Common Use of `nullable = false`
```hcl
variable "region" {
  type     = string
  nullable = false
  default  = "us-east-1"
}
```

With `nullable = false`, if a caller passes `null` for `region`, Terraform uses `"us-east-1"`
instead of propagating `null`. This is useful for optional-with-sensible-default patterns.

## Why It Matters
The interaction between `nullable`, `default`, and caller-supplied `null` is subtle. Declaring
`nullable = false` with a concrete default is the intended pattern.