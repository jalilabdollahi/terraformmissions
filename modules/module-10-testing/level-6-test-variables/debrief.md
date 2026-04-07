# Wrong Type in Test Variable Override

## What Was Broken
The `variables` block inside the `run` block set `item_count = "three"`, which is a string. The
variable declaration in `main.tf` requires `type = number`. Terraform cannot coerce `"three"`
to a number.

## Type Coercion in Tests
Terraform *can* coerce `"3"` (a numeric string) to `number`, but semantic strings like `"three"`
have no numeric representation and always fail.

## Variables Block in Tests
```hcl
run "my_test" {
  variables {
    item_count    = 3          # number literal — correct
    environment   = "staging"  # string literal
    enable_flag   = true       # boolean literal
    tags          = { team = "ops" }  # map literal
  }
}
```

## Why It Matters
Test variable overrides follow the same type rules as regular variable assignments. Understanding
HCL types prevents subtle bugs where the test itself is misconfigured rather than the module.