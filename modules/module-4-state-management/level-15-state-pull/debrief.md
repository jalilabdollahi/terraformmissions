# State Pull Inspector

## What Was Broken
`random_password` requires `length >= 1`. Setting `length = 0` causes an apply error because
the provider validates this constraint.

## The Fix
```hcl
resource "random_password" "secret" {
  length  = 16
  special = true
}
```

## terraform state pull
`terraform state pull` downloads the current state and prints it as JSON to stdout:
```bash
terraform state pull
terraform state pull | python3 -m json.tool    # pretty-print
terraform state pull | jq '.resources[].type'  # extract resource types
```

The state JSON structure:
```json
{
  "version": 4,
  "terraform_version": "1.5.x",
  "resources": [...],
  "outputs": {...}
}
```

## Why It Matters
Direct state inspection is useful for debugging, auditing, and building tooling around Terraform.
Always treat state as sensitive data — it may contain secrets.