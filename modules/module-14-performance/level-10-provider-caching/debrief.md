# Provider Caching

## What Was Broken
The version constraint `= 3.99.0` pins to a non-existent provider version. Terraform init
queries the registry, finds no matching version, and fails. In a provider caching scenario,
if `TF_PLUGIN_CACHE_DIR` contains version 3.6.1 but the constraint requires 3.99.0, the
cached version does not satisfy the constraint — cache miss, download attempt, failure.

## The Fix
Change to `~> 3.6` which matches the available 3.6.x line.

## TF_PLUGIN_CACHE_DIR Explained
```bash
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
mkdir -p "$TF_PLUGIN_CACHE_DIR"
terraform init
```

When a provider satisfying the constraint is in the cache directory, Terraform symlinks to it
instead of downloading. This dramatically speeds up `terraform init` in CI/CD environments.

**Requirements:**
- Cache directory must exist and be writable by the Terraform process
- Provider version in cache must satisfy the version constraint
- If constraint does not match any cached version → cache miss → fresh download

## Version Constraint Operators
| Operator | Meaning |
|---------|---------|
| `= 1.2.3` | Exact version only |
| `~> 1.2` | >= 1.2, < 2.0 (pessimistic) |
| `~> 1.2.3` | >= 1.2.3, < 1.3.0 (pessimistic patch) |
| `>= 1.2, < 2.0` | Range (explicit) |

## Key Takeaway
Use pessimistic constraints (`~>`) rather than exact pinning (`=`) for providers. Use
`.terraform.lock.hcl` for reproducibility — it records the exact version selected within
the constraint range.