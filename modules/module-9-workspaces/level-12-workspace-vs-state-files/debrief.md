# Invalid Backend Interpolation

## What Was Broken
The backend block used `${terraform.workspace}` in the path. Backend configuration is parsed
before the Terraform runtime starts — at that point, `terraform.workspace` does not exist yet.
Interpolation is simply not allowed in backend blocks.

## The Fix
```hcl
backend "local" {
  path = "terraform.tfstate"
}
```

## How Workspace State Isolation Works Automatically
| Workspace   | State file location |
|------------|---------------------|
| `default`  | `./terraform.tfstate` (or configured `path`) |
| `staging`  | `./terraform.tfstate.d/staging/terraform.tfstate` |
| `production` | `./terraform.tfstate.d/production/terraform.tfstate` |

Terraform handles this **automatically** — you do not need to encode workspace names in the path.

## When to Use Separate State Files (not workspaces)
For truly separate environments (different accounts, different providers), separate Terraform
root modules with separate state files and separate backends is safer than workspaces.
Workspaces share the same provider config and are best for small environmental differences.

## Key Rule
Backend blocks: **literal values only**. No variables, no locals, no expressions.
Use `-backend-config` CLI flags for dynamic backend configuration.