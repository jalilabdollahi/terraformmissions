# Reading the Debug Logs

## What Was Broken
The `source` for the `local` provider pointed to a non-existent registry:
`fakecorp.example.com/fakens/local`. Terraform tried to connect to this registry and failed.

## The Fix
```hcl
required_providers {
  local = {
    source  = "hashicorp/local"
    version = "~> 2.5"
  }
}
```

## TF_LOG Levels
| Level | What it shows |
|---|---|
| `ERROR` | Only errors |
| `WARN` | Warnings and errors |
| `INFO` | Informational messages |
| `DEBUG` | Detailed operation trace |
| `TRACE` | Extremely verbose — all API calls |

## Why It Matters
`TF_LOG=DEBUG` is your first tool when `terraform init` fails for non-obvious reasons.
The debug output shows exactly which registry Terraform is trying to contact and what response it received.