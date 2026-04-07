# Provider Not Found

## What Was Broken
The provider source `notarealregistry.example.com/fake/provider` does not exist.
Terraform tried to contact this registry and received a connection error or 404.

## The Fix
Use the real HashiCorp local provider:
```hcl
required_providers {
  local = {
    source  = "hashicorp/local"
    version = "~> 2.5"
  }
}
```

## Provider Source Format
`<hostname>/<namespace>/<type>` — the `hostname` defaults to `registry.terraform.io` when omitted.
So `hashicorp/local` is shorthand for `registry.terraform.io/hashicorp/local`.

## Why It Matters
`terraform init` is the first command in every workflow. A failing init blocks all subsequent
steps. Always validate provider sources against the Terraform Registry.