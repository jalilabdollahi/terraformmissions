# Off-by-One Output

## What Was Broken
`count = 3` creates indices 0, 1, 2. Referencing `[3]` is out of bounds.

## The Splat Expression
Instead of listing individual indices, use the splat operator `[*]`:
```hcl
output "file_names" {
  value = local_file.files[*].filename
  # Returns: ["file-0.txt", "file-1.txt", "file-2.txt"]
}
```

## Valid Indices for count = 3
- `[0]` — first instance
- `[1]` — second instance
- `[2]` — third instance
- `[3]` — out of bounds (error)

## Concepts
- `count` indices are always 0-based
- The splat `[*]` operator is the safest way to reference all count instances