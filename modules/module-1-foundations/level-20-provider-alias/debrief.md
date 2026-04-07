# Alias Identity

## What Was Broken
The `provider` meta-argument referenced `local.secondary`, but only `local.primary` was declared.

## Provider Aliases
Aliases allow multiple instances of the same provider — useful for different regions, accounts, or configs.

```hcl
provider "local" {
  alias = "primary"
}

provider "local" {
  alias = "secondary"
}

resource "local_file" "a" {
  provider = local.primary
  # ...
}

resource "local_file" "b" {
  provider = local.secondary
  # ...
}
```

## When You Need Aliases
- Multi-region deployments (one provider per region)
- Multi-account deployments
- Different provider configurations for different resources

## Default Provider
If no `alias` is set on a `provider` block, it becomes the *default* provider for that type.
Resources without a `provider` meta-argument use the default.