# Missing Output Declaration

## What Was Broken
A child module's resources are fully encapsulated — the parent cannot access their attributes
unless the child explicitly exposes them via an `output` block.

## Adding an Output to the Child Module
```hcl
output "filename" {
  value = local_file.greeting.filename
}
```

This makes `module.mymod.filename` available in the root.

## Encapsulation Principle
Child modules are black boxes. You must explicitly choose what to expose.
This is intentional: it keeps module APIs clean and stable.

## Concepts
- `output` blocks in a child module form its public interface.
- Resources inside a child module are never directly addressable from a parent.