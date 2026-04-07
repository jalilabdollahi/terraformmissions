# Missing Link in the Chain

## What Was Broken
`local_file.base` was referenced by both `local_file.processed` and `local_file.final`,
but the resource was never declared. Terraform reported multiple undeclared resource errors.

## The Fix
Add the missing resource:
```hcl
resource "local_file" "base" {
  content  = "base content"
  filename = "${path.module}/base.txt"
}
```

## Debugging Dependency Chains
1. Run `terraform validate` — it lists all undeclared references
2. Map out the dependency graph manually for complex chains
3. Use `terraform graph | dot -Tsvg > graph.svg` to visualize

## Why It Matters
When refactoring configurations, resources are sometimes accidentally deleted or moved.
`terraform validate` catches all dangling references before any infrastructure changes are made.