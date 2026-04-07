# Broken depends_on Reference

## What Was Broken
`depends_on = [module.nonexistent]` references a module label that is not declared anywhere.
Terraform validates all references at plan time, including `depends_on` arguments.

## depends_on Syntax
```hcl
resource "local_file" "note" {
  # ...
  depends_on = [module.hello]   # references a real module
}
```

## When to Use depends_on with Modules
Use `depends_on` on a module call to express that everything inside the module
should wait until the dependency is complete:
```hcl
module "app" {
  source     = "./modules/app"
  depends_on = [module.network]
}
```

## Concepts
- All `depends_on` values are validated — they must refer to declared resources or modules.
- `depends_on` forces ordering but does not pass data between objects.