# Backend Basics

## What Was Broken
The local backend was configured with `path = "../../nonexistent/terraform.tfstate"`. The directory
`../../nonexistent/` does not exist, so Terraform cannot write the state file there.

## The Fix
```hcl
backend "local" {
  path = "terraform.tfstate"
}
```

## Local Backend
The `local` backend stores state as a file on the filesystem. It's the default backend when no
`backend {}` block is specified (defaulting to `terraform.tfstate` in the working directory).

```hcl
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
```

## Why It Matters
Backend configuration is critical — it determines where state is stored and how locking works.
A wrong path can prevent `terraform init` from completing, blocking all operations.