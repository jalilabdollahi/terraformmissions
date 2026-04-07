# Targeted Apply

## What Was Broken
`resource_c` referenced `local_file.resource_b.content_md5`. This attribute does not exist on
`local_file` resources. The valid exported attributes are `filename`, `content`, `id`, and `content_base64`.

## The Fix
```hcl
resource "local_file" "resource_c" {
  content  = "Resource C — depends on B: ${local_file.resource_b.filename}"
  filename = "${path.module}/resource_c.txt"
}
```

## The -target Flag
`terraform apply -target=<address>` applies changes to only specific resources and their
dependencies. Useful for:
- Debugging individual resources
- Partial rollouts (use cautiously)

```bash
terraform apply -target=local_file.resource_a
```

**Warning:** Using `-target` regularly leads to configuration drift. Prefer full applies.

## Why It Matters
Understanding the dependency graph (A to B to C) is essential for debugging. When C fails, check
if B's attributes are what C expects.