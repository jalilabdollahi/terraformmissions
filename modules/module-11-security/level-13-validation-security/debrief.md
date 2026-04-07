# Wrong Operator in Password Length Validation

## What Was Broken
The validation condition `length(var.password) <= 8` passes for short passwords (1-8 chars) and
rejects long passwords (9+ chars). This is the opposite of a security-enforcing minimum-length
rule.

## Correct Security Validation
```hcl
validation {
  condition     = length(var.password) >= 8
  error_message = "Password must be at least 8 characters long."
}
```

## Composing Multiple Validations
```hcl
validation {
  condition     = length(var.password) >= 12
  error_message = "Password must be at least 12 characters."
}

validation {
  condition     = can(regex("[A-Z]", var.password))
  error_message = "Password must contain at least one uppercase letter."
}

validation {
  condition     = can(regex("[0-9]", var.password))
  error_message = "Password must contain at least one digit."
}
```

## Why It Matters
A backwards validation silently accepts weak passwords and rejects strong ones. This is a
security-critical bug that can go unnoticed because the config "validates successfully."