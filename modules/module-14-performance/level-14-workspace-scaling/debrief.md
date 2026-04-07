# Workspace Scaling

## What Was Broken
The workspace-based naming convention was incorrect in two ways:
1. **Wrong order**: `token_{N}_{workspace}` instead of `{workspace}-token-{N}`
2. **Wrong separator**: underscores (`_`) instead of dashes (`-`)

This inconsistency means resources in different workspaces would be named in a non-standard
way, making it hard to quickly identify the environment a resource belongs to.

## The Fix
Use `${terraform.workspace}-token-${count.index + 1}` consistently in both the keepers map
and the token_names output expression.

## Workspace Naming Best Practices
Convention: `{environment}-{resource-type}-{identifier}`

| Example | Environment | Resource | ID |
|---------|------------|---------|-----|
| `prod-token-1` | prod | token | 1 |
| `staging-token-1` | staging | token | 1 |
| `dev-token-1` | dev | token | 1 |

**Why environment first?**
- Resources sort by environment alphabetically
- Grepping logs for `prod-` finds all prod resources immediately
- Naming is self-describing when viewed in any tool

## Workspace Anti-Patterns
- Using workspaces for prod/non-prod isolation in large orgs → use separate accounts/subscriptions
- Not documenting the workspace convention → new team members use wrong names
- `terraform.workspace == "default"` in production → rename to match the environment

## Key Takeaway
Establish naming conventions early and enforce them consistently. Inconsistent naming across
workspaces compounds into a maintenance burden at hundreds or thousands of resources.