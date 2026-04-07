# The Infinite Loop

## What Was Broken
`local_file.a` referenced `local_file.b.filename`, and `local_file.b` referenced
`local_file.a.filename`. This creates a circular dependency — Terraform cannot determine
the order of creation.

## The Fix
Extract the filenames into `locals` that are computed independently:
```hcl
locals {
  a_path = "${path.module}/a.txt"
  b_path = "${path.module}/b.txt"
}
```
Both resources then reference `local.a_path` and `local.b_path` — no circular dependency.

## How Terraform Detects Cycles
Terraform builds a directed acyclic graph (DAG) of resource dependencies. If a cycle is
detected, `terraform validate` reports the cycle path.

## Why It Matters
Dependency cycles prevent Terraform from planning or applying. The fix is always to find the
indirect dependency (usually a known/static value) and extract it to a `local`.