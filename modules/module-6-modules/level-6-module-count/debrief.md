# Count Without count.index

## What Was Broken
The child module requires `var.name`. The `count = 2` meta-argument creates two instances,
but no `name` was passed at all.

## Using `count.index`
Inside a `module` block (or `resource` block) that uses `count`, `count.index` evaluates
to the current instance index (0-based):

```hcl
module "mymod" {
  count  = 2
  source = "./modules/item"
  name   = "app-${count.index}"   # "app-0", "app-1"
}
```

## Referencing Counted Module Outputs
```hcl
module.mymod[0].file_path
module.mymod[1].file_path
module.mymod[*].file_path   # splat — all instances
```

## Concepts
- `count.index` — zero-based index of the current instance
- Each module instance must produce unique resource addresses