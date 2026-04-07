# Incomplete Mock Provider

## What Was Broken
The `mock_provider "local" {}` block was empty. When Terraform applies with a mock provider,
it needs to know how to generate default values for the resource's computed attributes. Without
a `mock_resource` definition, the mock cannot satisfy the schema.

## mock_provider Structure
```hcl
mock_provider "local" {
  mock_resource "local_file" {
    defaults = {
      filename = "/tmp/test.txt"
      id       = "mock-id"
    }
  }
  mock_data "local_file" {
    defaults = {
      content = "mocked file content"
    }
  }
}
```

## When to Use Mock Providers
- Tests that should not create real infrastructure.
- Unit-testing module logic without provider API calls.
- CI pipelines without cloud credentials.

## Why It Matters
Mock providers allow fast, isolated tests. Understanding how to configure them properly —
including `mock_resource` defaults — is essential for effective Terraform unit testing.