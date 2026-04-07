# Duplicate Provider Configuration in Test

## What Was Broken
The test file declared two `provider "local" {}` blocks without aliases. Terraform only allows one
configuration per provider per alias. Duplicates cause a parse or validation error.

## Provider Blocks in Test Files
Test file `provider` blocks override the providers used during that test run. They follow the same
rules as provider configurations in `.tf` files:
- One configuration per provider name (without alias).
- Multiple configurations allowed if each has a unique `alias`.

## When You Need Multiple Provider Configs
```hcl
provider "aws" {
  alias  = "us-east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu-west"
  region = "eu-west-1"
}
```

## Why It Matters
Duplicate provider configurations are a sign of copy-paste errors. In test files, they often
appear when tests are assembled from snippets without checking for existing provider blocks.