# Drift Detector

## What Was Broken
The resource referenced `var.file_contents` but the variable was declared as `var.file_content`
(without the trailing 's'). Terraform cannot resolve undeclared variable references.

## The Fix
```hcl
resource "local_file" "tracked" {
  content  = var.file_content
  filename = "${path.module}/tracked.txt"
}
```

## Drift Detection
Drift occurs when the real-world state of a resource diverges from what Terraform has recorded.
Causes include manual changes, external automation, or provider-side modifications.

```bash
terraform plan -detailed-exitcode
# Exit 0 = no changes
# Exit 1 = error
# Exit 2 = changes detected (drift or config change)
```

## Why It Matters
Regular drift detection (often scheduled with `-detailed-exitcode` in CI pipelines) ensures your
infrastructure stays consistent with your code. Without it, silent drift accumulates and causes
unexpected behavior.