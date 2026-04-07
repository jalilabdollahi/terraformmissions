# for_each Module Reference

## What Was Broken
When a module uses `for_each`, it creates multiple instances, each identified by a key.
You cannot reference the module collection as a whole without specifying a key.

## Addressing for_each Instances
```hcl
module.mods["a"].file_path   # specific instance
module.mods["b"].file_path   # specific instance

# To get all file paths:
{ for k, mod in module.mods : k => mod.file_path }
```

## In the Module Block
```hcl
module "mods" {
  for_each = toset(["a", "b"])
  source   = "./modules/item"
  label    = each.key    # available inside the module block
}
```

## Concepts
- `for_each` module instances are addressed with `["key"]` notation.
- `each.key` / `each.value` are available inside the `module` block.