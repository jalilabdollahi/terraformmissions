# Precondition Fails on Its Own Default

## What Was Broken
The output's precondition requires `var.port >= 1024`. The variable's default is `80`, which
is below 1024 and fails the precondition. `terraform plan` reports the precondition error.

## The Fix
```hcl
variable "port" {
  type    = number
  default = 8080
}
```

## Output `precondition` Block (Terraform >= 1.2)

```hcl
output "service_url" {
  value = "http://example.com:${var.port}"

  precondition {
    condition     = var.port >= 1024
    error_message = "port must be >= 1024 (use an unprivileged port)."
  }
}
```

Preconditions are checked during `terraform plan`. If the condition is false, the plan fails with
the `error_message`.

## `precondition` vs `validation`

| Feature | `variable.validation` | `output.precondition` |
|--------|----------------------|----------------------|
| Where declared | Inside `variable` block | Inside `output` block |
| When checked | Variable assignment | Plan time |
| Can reference other vars | No (only `var.<name>`) | Yes (full expression) |

## Why It Matters
Preconditions on outputs let you express invariants that depend on multiple values — not just a
single variable. A default that violates a precondition is always a bug.