# Conditional Module Output Reference

## What Was Broken
`module.mymod.file_path` is invalid when the module uses `count`. With `count`,
all instances must be addressed by index: `module.mymod[0]`, `module.mymod[1]`, etc.

## Safe Conditional Output
```hcl
output "result_path" {
  value = try(module.mymod[0].file_path, "")
}
```

`try()` returns `""` when `count = 0` and `module.mymod[0]` doesn't exist.

## Pattern: Conditional Module
```hcl
module "mymod" {
  count  = var.enabled ? 1 : 0
  source = "./modules/mymod"
}

output "result_path" {
  value = try(module.mymod[0].file_path, "")
}
```

## Concepts
- `count`-based modules: `module.name[N]` — always use index notation
- `try(expr, fallback)` — safe access for potentially absent instances
- Conditional modules (`count = 0 or 1`) are a common Terraform pattern