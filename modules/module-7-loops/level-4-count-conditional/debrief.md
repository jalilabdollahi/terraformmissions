# String Bool in Conditional Count

## What Was Broken
`var.enabled ? 1 : 0` requires `var.enabled` to evaluate as a boolean.
`type = string` with `default = "true"` provides a string, which Terraform cannot
implicitly convert to bool in a ternary expression.

## The Fix
```hcl
variable "enabled" {
  type    = bool      # not string
  default = true      # not "true"
}
```

## HCL Boolean Literals
```hcl
default = true    # bool
default = false   # bool
default = "true"  # string (not a bool!)
```

## Concepts
- `bool` and `string` are distinct types in Terraform's type system
- Ternary `condition ? true_val : false_val` requires condition to be a bool