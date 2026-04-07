# Null and Void

## What Was Broken
`nullable = false` means the variable must never be null. A `default = null` contradicts this
because null *is* the absence of value.

## `nullable` in Terraform
Added in Terraform 1.1. Controls whether a variable can be `null`:

```hcl
variable "x" {
  type     = string
  nullable = false   # callers CANNOT pass null
  default  = "prod"  # must be a non-null default
}

variable "y" {
  type     = string
  nullable = true    # (default) callers CAN pass null
  default  = null    # fine — null is allowed
}
```

## Use Case
`nullable = false` is useful when you want to guarantee a variable always has a value,
preventing null-propagation bugs deep in your module.