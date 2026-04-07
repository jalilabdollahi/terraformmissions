# Partial Apply Recovery — Incident Post-Mortem

## The Incident
A previous `terraform apply` was interrupted (network timeout, process kill, operator error)
after creating only `resource_a`. The state file recorded this partial success. Resources B
and C were never created, leaving the deployment incomplete.

## The Recovery
Simply run `terraform apply` again. Terraform reads the partial state, sees what's missing,
and creates only the outstanding resources. The dependency chain (A → B → C) is respected.

## Why Terraform Handles This Well
Terraform applies are **idempotent within a state context**:
- Already-created resources (in state) are not recreated
- Missing resources (in config but not state) are created
- The dependency graph ensures creation order is correct

## Partial Apply Prevention
```bash
# Use -lock=true (default) to prevent concurrent applies
terraform apply -lock=true

# Use plan files to ensure atomic plan+apply
terraform plan -out=tfplan && terraform apply tfplan

# Remote backends with state locking prevent most partial applies
# (the lock is released only on clean completion)
```

## What Can Cause Partial Applies
- Network interruption during remote API calls
- Process signal (Ctrl+C, SIGTERM) during apply
- Provider timeout on a long-running resource creation
- CI/CD job timeout before apply completes

## Key Takeaway
After any interrupted apply, run `terraform plan` before doing anything else. The plan shows
exactly what completed and what didn't. Almost always, `terraform apply` to resume is safe.