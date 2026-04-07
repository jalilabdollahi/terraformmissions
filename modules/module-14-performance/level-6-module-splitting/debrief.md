# Module Splitting with moved Blocks

## What Was Broken
When resources are moved into a module without `moved` blocks, Terraform sees the old resource
addresses as "to be deleted" and the new module addresses as "to be created". This results in
a destroy + recreate cycle — potentially catastrophic for stateful resources in production.

## The Fix
Add one `moved` block per relocated resource, mapping the old address to the new module address.

## moved Block Syntax
```hcl
moved {
  from = random_string.token_a
  to   = module.strings.random_string.token_a
}
```

The `from` address is where the resource WAS. The `to` address is where it IS NOW.

## When to Use moved Blocks
- Moving resources into or out of modules
- Renaming resources within a module
- Changing `for_each` keys (causes address changes)
- Splitting or merging config root modules (as an alternative to `terraform state mv`)

## Key Takeaway
`moved` blocks are the safe, declarative, reviewable way to refactor Terraform configs without
destroying infrastructure. They are the preferred alternative to imperative `terraform state mv`.
Once all team members have applied the change, you can remove them.