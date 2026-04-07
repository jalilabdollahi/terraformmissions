# Block Disappeared

## What Was Broken
Without `required_providers`, Terraform falls back to the old provider discovery behaviour
(Terraform < 0.13) or errors on `terraform init` in newer versions because the source address
is unknown.

## The `terraform {}` Block
Every Terraform project should have a `terraform {}` block that declares:
- `required_version` — which Terraform version to use
- `required_providers` — where to find each provider and which version

```hcl
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
```

## Why It Matters
Explicit provider sources prevent Terraform from guessing the provider origin and ensure
reproducible builds across machines and CI pipelines.