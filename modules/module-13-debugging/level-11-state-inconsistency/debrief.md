# Ghost in the State

## What Was Broken
A stale `terraform.tfstate` was present, recording `local_file.config` as existing at
`/tmp/stale_config.txt`. The actual file doesn't exist at that path. Terraform's refresh
detected the inconsistency and reported an error.

## The Fix
```bash
rm -f terraform.tfstate terraform.tfstate.backup
terraform apply
```

## When State Becomes Inconsistent
1. State file copied from another environment
2. Resource manually deleted outside Terraform
3. State file from a different directory/workspace

## Recovery Options
- **Delete stale state** — for fully orphaned state files (as done here)
- **`terraform state rm`** — remove specific stale resource from state
- **`terraform import`** — if the real resource exists elsewhere and needs to be brought under management

## Why It Matters
State inconsistency is one of the most common real-world Terraform problems.
Understanding when to delete, import, or fix state is a critical operational skill.