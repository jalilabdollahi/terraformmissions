# Asserting Applied Values During Plan

## What Was Broken
The `run` block used `command = "plan"`, but the assertion checked `output.file_id` — an attribute
that is only computed after the resource is applied. During plan, this value is unknown, causing
the assertion to fail.

## Plan vs Apply in Tests

| Attribute type              | Available during `plan`? | Available during `apply`? |
|-----------------------------|--------------------------|---------------------------|
| Input variables             | Yes                       | Yes                       |
| Static locals               | Yes                       | Yes                       |
| Resource-computed attributes | No (unknown)             | Yes                       |
| Output referencing computed  | No                       | Yes                       |

## When to Use Each
- **`command = "plan"`**: Test variable validation, structural checks, or that no changes are
  planned after an idempotent apply.
- **`command = "apply"`**: Test actual resource creation, computed attribute values, and
  integration between resources.

## Why It Matters
Using the wrong command leads to flaky tests that fail on computed values. Choosing `plan` when
you need post-apply values is a common early mistake in Terraform testing.