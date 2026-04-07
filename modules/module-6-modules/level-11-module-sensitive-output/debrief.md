# Sensitive Output Leak

## What Was Broken
`var.secret` is declared `sensitive = true`. When that value flows into an `output` block,
Terraform requires the output to also be marked `sensitive = true`.

## Marking Outputs Sensitive
```hcl
output "secret_content" {
  value     = var.secret
  sensitive = true   # required when value is sensitive
}
```

## Sensitive Propagation Rules
- A sensitive value used anywhere in an output's `value` expression makes the entire output sensitive.
- Terraform will raise an error if you try to use a sensitive value in a non-sensitive output.
- Sensitive outputs are displayed as `(sensitive value)` in `terraform output`.

## Concepts
- `sensitive = true` on a variable or output hides the value in logs/output.
- Sensitivity propagates through expressions — you must mark the output sensitive too.