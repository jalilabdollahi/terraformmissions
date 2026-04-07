# Lazy Evaluation and templatefile()

## What Was Broken
The `templatefile()` function was called with a path pointing to a non-existent file:
`templates/configs/service.tpl`. The actual template is at `templates/service.tpl`.

Since `templatefile()` is evaluated once per `for_each` entry at plan time, Terraform attempts
to read the file 10 times — all 10 fail immediately with a file-not-found error.

## The Fix
Correct the path: `templates/configs/service.tpl` → `templates/service.tpl`.

## Evaluation Efficiency with for_each
When using functions like `templatefile()` in a `for_each` loop:
- The function is called **N times** during planning (once per map entry)
- For identical templates with the same variables across all entries, precompute in `locals`
- For entry-specific templates (different vars per entry), the per-iteration call is unavoidable

```hcl
# Precompute in locals when template content is identical for all entries
locals {
  shared_config = templatefile("${path.module}/templates/shared.tpl", {
    env = var.environment
  })
}
```

## Key Takeaway
`templatefile()` reads the file at plan time. The path must be correct before the first plan.
Always use `${path.module}` to anchor paths to the module directory — this prevents breakage
when Terraform is run from a different working directory.