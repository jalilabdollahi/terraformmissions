# Missing Splat on Count Resource

## What Was Broken
`local_file.config.filename` is not valid when `count > 1`. Terraform doesn't know
whether you want a specific instance or all of them.

## The Splat Operator [*]
```hcl
output "all_filenames" {
  value = local_file.config[*].filename
  # Returns a list: ["config-0.txt", "config-1.txt", "config-2.txt"]
}
```

## Specific Instance
```hcl
output "first_filename" {
  value = local_file.config[0].filename
}
```

## Concepts
- `[*]` splat — returns a list of the attribute across all instances
- Without `[N]` or `[*]`, referencing a count resource is a validation error