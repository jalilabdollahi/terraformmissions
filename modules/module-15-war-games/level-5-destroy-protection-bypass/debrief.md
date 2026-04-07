# Destroy Protection Bypass — Incident Post-Mortem

## The Incident
`prevent_destroy = true` was placed on the wrong resource — `temp_resource` instead of
`protected_data`. When the team tried to decommission `temp_resource` with `plan -destroy`,
Terraform blocked the operation, citing the prevent_destroy lifecycle constraint.

## The Fix
Move the `lifecycle { prevent_destroy = true }` block from `temp_resource` to `protected_data`.

## prevent_destroy Mechanics
When `prevent_destroy = true` is set on a resource:
- `terraform plan -destroy` errors if the plan would destroy that resource
- `terraform apply` errors if the plan includes destruction of that resource
- The ONLY way to destroy the resource is to first remove `prevent_destroy = true` from config,
  then plan and apply

## When to Use prevent_destroy
Appropriate use cases:
- Production databases (RDS, Cloud SQL)
- DNS zones with live traffic
- Identity/auth resources (service accounts, IAM roles)
- Resources with data that cannot be recreated

**Not appropriate for:**
- Ephemeral resources (temp files, generated tokens)
- Resources managed by multiple configs
- Resources you intend to recreate regularly

## Key Takeaway
`prevent_destroy` is a powerful safety mechanism but must be applied deliberately. Review all
`lifecycle` blocks during code review to ensure they are on the right resources.