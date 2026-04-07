# Sensitive is a Bool, Not a String

## What Was Broken
`sensitive = "true"` is a string. The `sensitive` meta-argument of an `output` block is typed as
`bool`, so it requires the unquoted boolean literal `true`.

## The Fix
```hcl
output "api_key" {
  value     = var.api_key
  sensitive = true
}
```

## `output` Meta-Arguments

| Argument      | Type   | Description |
|--------------|--------|-------------|
| `value`       | any    | The value to expose |
| `description` | string | Human-readable description |
| `sensitive`   | bool   | Hide value in plan/apply output |
| `depends_on`  | list   | Explicit dependencies |
| `precondition`| block  | Validate the output value |

## What `sensitive = true` Does
- Masks the value in `terraform plan` and `terraform apply` output (shown as `(sensitive value)`)
- Does **not** encrypt the value in state — it is still stored in plaintext in `terraform.tfstate`
- Prevents the value from being logged in most CI systems

## Why It Matters
The `"true"` vs `true` distinction catches many developers off guard. It is the same class of
error as `"false"` for booleans. Always use unquoted `true`/`false` for boolean attributes.