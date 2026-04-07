# Full Recovery Playbook — Incident Post-Mortem

## The Incident
A production incident left three simultaneous issues:
1. **Stale state entry** — `random_id.old_resource` in state from a previous type migration
2. **Missing moved block** — `random_string.old_name` renamed to `new_name` without tracking
3. **Wrong attribute** — `random_string.config_error` had `length = 0` (invalid)

## Systematic Recovery Procedure

### Step 1: Diagnose
```bash
terraform state list     # see what's in state
terraform plan           # see all errors at once
```

### Step 2: Prioritize
Fix issues in order of severity:
1. State corruption (blocks all other operations)
2. Missing moved blocks (causes unintended destroys)
3. Config errors (prevents plan/apply)

### Step 3: Fix
1. `terraform state rm random_id.old_resource` (stale type)
2. Add `moved { from = random_string.old_name  to = random_string.new_name }` (rename)
3. Change `length = 0` to `length = 8` (attribute fix)

### Step 4: Verify
```bash
terraform plan   # should show no destroy, only the moved resource and attribute update
terraform apply
terraform plan   # final check — should show "No changes"
```

## Key Takeaway
Complex incidents require systematic diagnosis before action. Run `terraform plan` and read
ALL errors before starting fixes. Fix issues in dependency order: state issues first,
structural issues (moved) second, attribute issues last.