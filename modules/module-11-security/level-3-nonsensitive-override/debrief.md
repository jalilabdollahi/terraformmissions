# Direct nonsensitive() on Secret Variable

## What Was Broken
`output "exposed_secret" { value = nonsensitive(var.secret) }` directly stripped the sensitive
marking from a secret variable. The raw value would be displayed in `terraform output`.

## The Correct Pattern
```hcl
output "exposed_secret" {
  value     = var.secret
  sensitive = true
}
```

## Security Principle: Least Privilege Output
Outputs should expose the minimum information necessary. If a downstream consumer needs to
*use* the secret (e.g., pass it to another module), mark the output `sensitive = true` so
it is protected end-to-end. If the downstream consumer does not need the value at all,
do not output it.

## Why nonsensitive() Exists
`nonsensitive()` is an escape hatch for situations where the sensitive marking was applied
too broadly. For example, if a function returns a sensitive value but you have already
sanitized it:
```hcl
output "sanitized" {
  # replace() with a redaction — the result is safe to show
  value = nonsensitive(replace(var.secret, "/./", "*"))
}
```

## Why It Matters
Every misuse of `nonsensitive()` is a potential credential leak in CI logs, plan files, and
terminal history. Code-review `nonsensitive()` calls as security-critical changes.