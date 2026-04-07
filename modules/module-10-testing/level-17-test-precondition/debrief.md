# Wrong expect_failures Target for Precondition

## What Was Broken
The `expect_failures` list referenced `local_file.config`, but the failing check is a `validation`
block on `variable "filename"`. Terraform's `expect_failures` must reference the exact location
of the failing check.

## Mapping Checks to expect_failures Targets

| Check type               | Target format              |
|--------------------------|----------------------------|
| Variable `validation`    | `var.<name>`               |
| Resource `precondition`  | `resource_type.name`       |
| Resource `postcondition` | `resource_type.name`       |
| Output `precondition`    | `output.<name>`            |

## Why Precision Matters
If `expect_failures` targets the wrong check, Terraform either:
- Reports the test as passing (the wrong check is targeted and happens to not fail), or
- Reports an unexpected failure at the correct check.

Both outcomes make tests unreliable. Matching the target to the check's location is essential.