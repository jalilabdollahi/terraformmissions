# Drift Reconciliation — Incident Post-Mortem

## The Incident
Three resources had configuration drift — their attributes in the Terraform config did not
reflect the desired state. This is a common scenario after manual changes, rushed hotfixes,
or copy-paste errors during initial setup.

## The 3 Drifts
1. `api_key.length`: 8 → 16 (too short for secure API key use)
2. `session_token.special`: false → true (needed special chars for session security)
3. `admin_token.upper`: false → true (needed mixed case for admin token complexity)

## Drift Detection Workflow
```bash
# 1. Run plan to see what Terraform wants to change
terraform plan

# 2. For external drift (infrastructure changed outside Terraform):
terraform apply -refresh-only  # accept drift into state

# 3. For config drift (config doesn't match desired state):
# Fix the config, then:
terraform apply  # converge config to desired state
```

## Types of Drift
| Type | What drifted | Fix |
|------|-------------|-----|
| Config drift | Terraform config ≠ desired state | Fix the config |
| Infrastructure drift | Real infra ≠ Terraform state | Use -refresh-only to accept, or apply to revert |
| State drift | State ≠ real infra (e.g. manual delete) | Apply to recreate, or terraform import |

## Key Takeaway
Regular `terraform plan` runs in CI detect drift early. In production, run `plan` on a schedule
(e.g. nightly) and alert on unexpected changes. This is sometimes called "drift detection mode."