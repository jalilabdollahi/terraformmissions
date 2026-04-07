# Heredoc Headache

## What Was Broken
`<<EOF` (non-indented heredoc) requires the closing `EOF` marker to be at column 0.
The closing `  EOF` was indented, so Terraform kept reading past it.

## Two Heredoc Forms
| Form | Closing marker | Strips indentation |
|------|---------------|-------------------|
| `<<EOF` | Must be at column 0 | No |
| `<<-EOF` | Can be indented | Yes (strips leading whitespace) |

## Best Practice
Always use `<<-EOF` when your content is indented inside an HCL block.
This keeps the code visually aligned without requiring the closing marker to break indentation.

```hcl
content = <<-EOF
  line 1
  line 2
EOF
```