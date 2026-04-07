# UUID Got the Wrong Attribute

## What Was Broken
`random_uuid` exposes the generated UUID through `.id`, not `.result`. The output was referencing
a non-existent `.result` attribute.

## The Fix
```hcl
output "app_id" {
  value = random_uuid.app_id.id
}
```

## Random Resource Attribute Reference

| Resource          | Generated value attribute |
|------------------|--------------------------|
| `random_string`   | `.result`                |
| `random_password` | `.result`                |
| `random_integer`  | `.result`                |
| `random_pet`      | `.id`                    |
| `random_uuid`     | `.id`                    |
| `random_id`       | `.hex`, `.dec`, `.b64_url`, `.b64_std` |

## Why It Matters
Each resource exposes its generated value under a specific attribute name. Checking the provider
documentation (or running `terraform providers schema`) prevents this class of error.