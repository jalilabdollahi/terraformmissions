# Splat Expression

## What Was Broken
`local_file.config[*].filename` used a splat expression on a resource without `count` or
`for_each`. Without these, a resource is a single instance — not iterable with `[*]`.

## The Fix
```hcl
resource "local_file" "config" {
  count    = 2
  content  = "config content ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}

output "all_filenames" {
  value = local_file.config[*].filename
  # → ["./config-0.txt", "./config-1.txt"]
}
```

## Splat Expressions
```hcl
# resource with count → splat produces a list
resource.name[*].attribute

# resource with for_each → use values() for map iteration
values(resource.name)[*].attribute

# Alternative with for expression
[for r in resource.name : r.attribute]
```

## Why It Matters
Splat expressions are concise list comprehensions for resource attributes. They only apply
to resources that produce multiple instances via `count` or `for_each`.