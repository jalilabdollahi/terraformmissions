# Prevent Destroy Removal

## What Was Broken
`lifecycle { prevent_destroy = true }` guards against accidental destruction. While valuable
in production, it blocked the destroy plan in this exercise.

## The Fix
```hcl
lifecycle {
  prevent_destroy = false
}
```
Or remove the lifecycle block entirely.

## prevent_destroy
```hcl
resource "aws_rds_cluster" "database" {
  lifecycle {
    prevent_destroy = true
  }
}
```

`prevent_destroy = true` causes `terraform plan` (and `apply`) to error when the resource
would be destroyed — even for planned replacements triggered by attribute changes.

To destroy a resource with `prevent_destroy = true`:
1. Change it to `false` in code
2. `terraform apply` the change
3. Then `terraform destroy`

## Why It Matters
`prevent_destroy` is a safety net for critical resources (databases, state buckets). Understanding
when to add and remove it is part of responsible Terraform management.