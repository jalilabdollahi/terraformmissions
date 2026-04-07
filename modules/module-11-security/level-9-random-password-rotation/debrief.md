# Password Forced to Rotate on Every Apply

## What Was Broken
`keepers = { always_rotate = timestamp() }` causes the password to be replaced on every
`terraform apply` because `timestamp()` returns a new value each time Terraform evaluates it.

## How keepers Work
`keepers` is a map. When any value in the map changes between runs, `random_password` generates
a new password. The idea is to tie password rotation to meaningful events:

```hcl
keepers = {
  version = var.password_version   # rotate by bumping the version variable
}
```

To force an immediate rotation, change `var.password_version` from `"v1"` to `"v2"`.

## Functions That Are Unstable in keepers
Avoid using these in `keepers` unless forced rotation is intentional:
- `timestamp()` — changes every plan
- `uuid()` — generates a new UUID every plan
- `plantimestamp()` — changes every plan

## Why It Matters
Uncontrolled password rotation means every `terraform apply` invalidates credentials across all
systems that use them. This causes outages and forces emergency credential rotations.