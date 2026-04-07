# Depending on a Ghost

## What Was Broken
`depends_on` must reference real resources declared in the configuration. `local_file.nonexistent`
doesn't exist, so Terraform reports an undefined reference error during validate.

## The Fix
```hcl
depends_on = [local_file.config]
```

Or remove `depends_on` entirely if no explicit ordering is required.

## When to Use `depends_on`
Use `depends_on` only when Terraform cannot detect a dependency automatically — for example, when
there is a side-effect dependency with no direct attribute reference:

```hcl
# Terraform cannot infer this: the IAM policy must be attached before the EC2 instance starts
resource "aws_instance" "worker" {
  depends_on = [aws_iam_role_policy_attachment.worker_policy]
}
```

When you use an attribute reference (e.g., `local_file.config.filename`), Terraform infers the
dependency automatically — no `depends_on` needed.

## Why It Matters
Referencing non-existent resources in `depends_on` is a common copy-paste error. Terraform catches
it at validate time, well before any infrastructure changes are made.