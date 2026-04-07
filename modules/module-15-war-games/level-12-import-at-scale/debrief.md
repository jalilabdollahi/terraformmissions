# Import at Scale — Incident Post-Mortem

## The Incident
During a bulk import of 5 resources into Terraform management, 2 of the 5 import blocks
had incorrect `id` values. For `random_string`, the import ID is the result string itself.
Wrong IDs cause import failures — Terraform cannot find the resource to import.

## The Fix
Correct the two wrong import IDs to match the actual resource values:
- `res_b`: `wrong-id-b` → `tokenb001`
- `res_d`: `wrong-id-d` → `tokend001`

## Import Block Syntax (Terraform >= 1.5)
```hcl
import {
  id = "<provider-specific-id>"
  to = <resource_address>
}
```

## Finding the Right Import ID
The correct import ID format varies by provider and resource type:
- **random_string**: the `result` value (the generated string)
- **AWS EC2**: instance ID (`i-1234567890abcdef0`)
- **AWS S3 Bucket**: bucket name
- **local_file**: the file path

Always check the provider documentation for the resource type's import syntax.

## Bulk Import Strategy
For large-scale imports:
1. List all resource IDs from the existing infrastructure inventory
2. Write import blocks for all resources
3. Run `terraform plan` — it shows import errors immediately for wrong IDs
4. Fix wrong IDs iteratively until plan is clean
5. Apply to commit the imports to state

## Key Takeaway
When importing at scale, verify import IDs against actual infrastructure before applying.
The `terraform plan` step with import blocks is non-destructive — use it to validate all
IDs are correct before committing.