# Module Composition Mismatch

## What Was Broken
The root passed an argument named `config_file` to Module B, but Module B's input variable
is called `config_path`. The argument name must match the variable name exactly.

## Wiring Modules Together
```hcl
module "mod_a" {
  source = "./modules/mod_a"
}

module "mod_b" {
  source      = "./modules/mod_b"
  config_path = module.mod_a.config_path   # name matches variable
}
```

## Module Composition Pattern
Module A's output → Root wires → Module B's input.
This is the standard way to build larger systems from smaller, focused modules.

## Concepts
- Module argument names must match the child module's declared variable names.
- Use `terraform validate` to catch argument name mismatches early.