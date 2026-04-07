# Targeted Operations

## What Was Broken
Resource C's `keepers` map referenced `random_string.resource_a.id`, but the `random_string`
resource type does not expose an `id` attribute — it exposes `result`. This caused a validation
error that prevented any operation from running.

## The Fix
Change `random_string.resource_a.id` → `random_string.resource_a.result`.

## Why -target Matters
`terraform apply -target=<address>` lets you apply only a specific resource (and its dependencies).
This is powerful for:
- Unblocking a single resource without touching others
- Debugging a specific resource in a large config
- Incremental apply in complex dependency graphs

**Warning:** Using `-target` regularly leaves state partially applied and can cause drift from
the config. Use it as a debugging and emergency tool, not a standard workflow.

## Key Takeaway
Always verify resource attribute names against the provider schema. `terraform validate` catches
these before a plan is attempted. Use `-target` tactically for targeted debugging.