# Production Hardening — Incident Post-Mortem

## The Incident
A config that was promoted to production was missing four critical hardening patterns,
creating security and reliability risks:
1. **Unmasked sensitive output** — token value exposed in CI logs
2. **No prevent_destroy** — critical token could be accidentally deleted
3. **No variable validation** — invalid token lengths (e.g. 1 or 2) could be applied
4. **No precondition** — no runtime check that the token meets security requirements

## The Four Hardening Patterns

### 1. Sensitive Outputs
```hcl
output "critical_token_value" {
  value     = random_string.critical_token.result
  sensitive = true  # redacts value in plan/apply output
}
```

### 2. prevent_destroy
```hcl
lifecycle {
  prevent_destroy = true  # blocks accidental deletion
}
```

### 3. Variable Validation
```hcl
validation {
  condition     = var.token_length >= 8
  error_message = "token_length must be >= 8."
}
```
Validates at `terraform plan` time — fails fast before any infrastructure changes.

### 4. Preconditions (Terraform >= 1.2)
```hcl
precondition {
  condition     = random_string.critical_token.length >= 8
  error_message = "Critical token length must be >= 8."
}
```
Validates during apply — can reference computed resource attributes.

## Production Hardening Checklist
- [ ] All secret outputs marked `sensitive = true`
- [ ] Critical resources have `prevent_destroy = true`
- [ ] All input variables have `validation` blocks for security constraints
- [ ] Critical outputs have `precondition` blocks for runtime assertions
- [ ] State backend uses encryption and versioning
- [ ] State locking is enabled
- [ ] Provider version constraints use `~>` with committed lock file

## Key Takeaway
Production hardening is not optional. Each missing pattern is a potential incident.
Build these patterns into your module templates and code review checklists from day one.