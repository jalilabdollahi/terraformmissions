# State List and Naming

## What Was Broken
The resource was named `count`, which is a reserved Terraform meta-argument. Terraform uses `count`
as a special instruction inside resource blocks — it cannot also be a resource name.

## The Fix
```hcl
resource "random_string" "epsilon" {
  length  = 6
  special = false
}
```

## Reserved Names
These names cannot be used as resource labels:
- `count`
- `for_each`
- `depends_on`
- `provider`
- `lifecycle`
- `connection`
- `provisioner`

## terraform state list
After a successful apply, `terraform state list` shows all tracked resources:
```bash
terraform state list
# random_string.alpha
# random_string.beta
# random_string.gamma
# random_string.delta
# random_string.epsilon
```

## Why It Matters
Clear, non-reserved resource names make configurations readable and prevent conflicts with
Terraform's own meta-arguments.