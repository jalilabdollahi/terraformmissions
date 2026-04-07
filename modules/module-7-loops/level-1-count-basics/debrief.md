# Three Files, Same Name

## What Was Broken
`filename = "${path.module}/config.txt"` is the same for all three `count` instances.
Each resource instance needs a unique address — and in this case, a unique file path.

## Using count.index
```hcl
resource "local_file" "config" {
  count    = 3
  content  = "config instance ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}
# Creates: config-0.txt, config-1.txt, config-2.txt
```

## Addressing Counted Resources
```hcl
local_file.config[0].filename   # "config-0.txt"
local_file.config[1].filename   # "config-1.txt"
local_file.config[*].filename   # all three via splat
```

## Concepts
- `count.index` — zero-based index available in `count`-based resources
- Every resource instance must have a unique set of argument values that produce unique identifiers