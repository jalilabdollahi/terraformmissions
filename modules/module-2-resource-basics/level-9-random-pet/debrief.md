# A Number is Not a Separator

## What Was Broken
`separator` is a `string` attribute. In HCL, `123` (no quotes) is a number literal. Terraform's
type system detects the mismatch and reports an error during validate.

## The Fix
```hcl
separator = "-"
```

## HCL Primitive Type Literals

| Type   | Example              |
|--------|---------------------|
| string | `"hello"`, `"-"`    |
| number | `42`, `3.14`        |
| bool   | `true`, `false`     |

Always use double quotes for string values.

## Why It Matters
Type mismatches between number literals and string attributes are a common beginner mistake in HCL.
The distinction between `"123"` (string) and `123` (number) matters. Terraform's type checker catches
these at validate time — before any resources are created.