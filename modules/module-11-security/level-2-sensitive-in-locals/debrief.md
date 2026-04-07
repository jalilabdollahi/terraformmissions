# nonsensitive() Stripping Sensitivity

## What Was Broken
`nonsensitive(local.password)` deliberately stripped the sensitive marking from a password.
Terraform then treated the output as non-sensitive and printed it to the terminal.

## How Sensitivity Propagates Through Locals
When a sensitive value is assigned to a `locals` block entry, Terraform automatically marks
that local as sensitive. No annotation is needed in `locals {}`:

```hcl
variable "secret" {
  sensitive = true
}

locals {
  derived = var.secret  # also sensitive — automatically
}
```

## When nonsensitive() Is Appropriate
`nonsensitive()` should only be used when you have **verified** the value has been transformed
to no longer contain sensitive data, for example:
```hcl
output "password_length" {
  value = nonsensitive(length(var.password))  # length is not sensitive
}
```

## Why It Matters
Misuse of `nonsensitive()` is a common way to accidentally bypass Terraform's sensitivity system.
Treat it like a security assertion: only use it when you can prove the value is safe to expose.